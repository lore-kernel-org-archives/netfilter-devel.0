From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] ulogd: Restructures signal handling by self-pipe trick.
Date: Fri, 05 Feb 2016 11:57:31 +0100
Message-ID: <1454669851.7857.15.camel@regit.org>
References: <1454421701-12839-1-git-send-email-ishii.hironobu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:47353 "EHLO home.regit.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbcBEK5l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2016 05:57:41 -0500
In-Reply-To: <1454421701-12839-1-git-send-email-ishii.hironobu@jp.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Tue, 2016-02-02 at 23:01 +0900, Hironobu Ishii wrote:
> ulogd had a critical bug that is calling Async-Signal-Unsafe
> functions
> in signal hander context.

Thanks a lot for this detailed bug report and fix. I'm gonna apply it
with minor white space fixes.

BR,
--
Eric.


> =A0 - Most of libc functions like fopen(), malloc() are Async-Signal-
> Unsafe.
> =A0=A0=A0=A0So you should not call these functions in signal handler =
context.
> =A0 - Calling pluginstances in signal handler context is danger.
> =A0=A0=A0=A0For implementer of pluginstances, it is very hard to reco=
gnize
> their
> =A0=A0=A0=A0functions are called in signal handler context.
>=20
> To solve the issue, I restructured signal handling by self-pipe
> trick.
> For more detail on self-pipe trick, please see the following.
> https://lwn.net/Articles/177897/
>=20
> This patch will solve various symptoms like following.
> =A0 - Deadlock
> =A0 - Segmentation fault caused by libc management data corruption,
> =A0 - Other unpredictable behavior.
>=20
> Deadlock example
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> This bug was already filed at:
> https://bugzilla.netfilter.org/show_bug.cgi?id=3D1030
>=20
> I also hit this bug. The backtrace of this issue is following.
> In this case, main thread was calling ctime(),
> and signal handler called localtime_r().
> That caused the dead lock while getting tzset_lock in __tz_convert().
> Because vsyslog() is Async-Signal-Unsafe function, we cannot call
> this function in signal handler context.
>=20
> =A0(gdb) bt
> =A0#0=A0=A0__lll_lock_wait_private () at
> ../nptl/sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:95
> =A0#1=A0=A00x00007f3c3fc7e4ac in _L_lock_2462 () at tzset.c:621
> =A0#2=A0=A00x00007f3c3fc7e2e7 in __tz_convert (timer=3D0x7f3c3ff8bf00
> <tzset_lock>,
> =A0=A0=A0=A0=A0timer@entry=3D0x7fffcfa923b8, use_localtime=3Duse_loca=
ltime@entry=3D1,
> =A0=A0=A0=A0=A0tp=3Dtp@entry=3D0x7fffcfa92400) at tzset.c:624
> =A0#3=A0=A00x00007f3c3fc7c28d in __localtime_r (t=3Dt@entry=3D0x7fffc=
fa923b8,
> =A0=A0=A0=A0=A0tp=3Dtp@entry=3D0x7fffcfa92400) at localtime.c:32
> =A0#4=A0=A00x00007f3c3fcbf1ba in __GI___vsyslog_chk (pri=3D<optimized=
 out>,
> flag=3D1,
> =A0=A0=A0=A0=A0fmt=3D0x406fa8 "signal received, calling pluginstances=
\n",
> ap=3D0x7fffcfa924a0)
> =A0=A0=A0=A0=A0at ../misc/syslog.c:199
> =A0#5=A0=A00x00000000004037b5 in __ulogd_log ()
> =A0#6=A0=A00x00000000004047be in signal_handler ()
> =A0#7=A0=A0<signal handler called>
> =A0#8=A0=A00x00007f3c3fcb62f5 in __GI___xstat (vers=3D<optimized out>=
,
> =A0=A0=A0=A0=A0name=3D0x7f3c3fd4b2c3 "/etc/localtime", buf=3D0x7fffcf=
a92c10)
> =A0=A0=A0=A0=A0at ../sysdeps/unix/sysv/linux/wordsize-64/xstat.c:37
> =A0#9=A0=A00x00007f3c3fc7e5f6 in __tzfile_read (file=3Dfile@entry=3D0=
x7f3c3fd4b
> 2c3 "/etc/localtime",
> =A0=A0=A0=A0=A0extra=3Dextra@entry=3D0, extrap=3Dextrap@entry=3D0x0) =
at tzfile.c:170
> =A0#10 0x00007f3c3fc7d954 in tzset_internal (always=3D<optimized out>=
,
> =A0=A0=A0=A0=A0explicit=3Dexplicit@entry=3D1) at tzset.c:444
> =A0#11 0x00007f3c3fc7e303 in __tz_convert (timer=3D0x7fffcfa92d50,
> =A0=A0=A0=A0=A0use_localtime=3Duse_localtime@entry=3D1, tp=3Dtp@entry=
=3D0x7f3c3ff8ed80
> <_tmbuf>)
> =A0=A0=A0=A0=A0at tzset.c:629
> =A0#12 0x00007f3c3fc7c2a1 in __GI_localtime (t=3D<optimized out>) at
> localtime.c:42
> =A0#13 0x00007f3c3fc7c1f9 in ctime (t=3D<optimized out>) at ctime.c:2=
7
> =A0#14 0x00007f3c3e180ec2 in ?? ()
> =A0#15 0x0000000056a100c2 in ?? ()
> =A0#16 0xf8570f79d4fc4200 in ?? ()
> =A0#17 0x000000000209bec0 in ?? ()
> =A0#18 0x00007f3c4059f1f8 in ?? ()
> =A0#19 0x000000000000003c in ?? ()
> =A0#20 0x0000000000404952 in ulogd_propagate_results ()
> =A0#21 0x00007f3c3f9cc203 in ?? ()
> =A0#22 0x0000000000000000 in ?? ()
>=20
> Segmentation fault in free()
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> From my experience, I think this was caused by some routine called
> malloc()/free() in signal handler context.
> By that, malloc() management data became inconsistent.
> As a result, free() made a wrong dereference.
>=20
> Program terminated with signal SIGSEGV, Segmentation fault.
> =A0#0=A0=A0__GI___libc_free (mem=3D0x7f430f011000) at malloc.c:2903
> =A02903=A0=A0=A0=A0=A0=A0if (chunk_is_mmapped(p))=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* release
> mmapped memory. */
> =A0(gdb) bt
> =A0#0=A0=A0__GI___libc_free (mem=3D0x7f430f011000) at malloc.c:2903
> =A0#1=A0=A00x00007f430e68affa in __GI__IO_free_backup_area (fp=3Dfp@e=
ntry=3D0x7
> 42500)
> =A0=A0=A0=A0=A0at genops.c:210
> =A0#2=A0=A00x00007f430e68a795 in _IO_new_file_overflow (f=3D0x742500,=
 ch=3D-1)
> at fileops.c:849
> =A0#3=A0=A00x00007f430e689511 in _IO_new_file_xsputn (f=3D0x742500,
> data=3D<optimized out>, n=3D15)
> =A0=A0=A0=A0=A0at fileops.c:1372
> =A0#4=A0=A00x00007f430e65aa4d in _IO_vfprintf_internal (s=3Ds@entry=3D=
0x742500,
> =A0=A0=A0=A0=A0format=3D<optimized out>, format@entry=3D0x7f430cbc400=
8 "%.15s %s
> %s",
> =A0=A0=A0=A0=A0ap=3Dap@entry=3D0x7fff456ece38) at vfprintf.c:1635
> =A0#5=A0=A00x00007f430e71d615 in ___fprintf_chk (fp=3D0x742500, flag=3D=
flag@ent
> ry=3D1,
> =A0=A0=A0=A0=A0format=3Dformat@entry=3D0x7f430cbc4008 "%.15s %s %s") =
at
> fprintf_chk.c:36
> =A0#6=A0=A00x00007f430cbc3f04 in fprintf (__fmt=3D0x7f430cbc4008 "%.1=
5s %s
> %s",
> =A0=A0=A0=A0=A0__stream=3D<optimized out>) at /usr/include/bits/stdio=
2.h:97
> =A0#7=A0=A0_output_logemu (upi=3D0x74e5a0) at ulogd_output_LOGEMU.c:1=
02
> =A0#8=A0=A00x0000000000404952 in ulogd_propagate_results ()
> =A0#9=A0=A00x00007f430e40f203 in interp_packet (ldata=3D0x7fff456ed06=
0,
> pf_family=3D2 '\002',
> =A0=A0=A0=A0=A0upi=3D0x74a6b0) at ulogd_inppkt_NFLOG.c:400
> =A0#10 msg_cb (gh=3D<optimized out>, nfmsg=3D0x7f430efe2020,
> nfa=3D0x7fff456ed060, data=3D0x74a6b0)
> =A0=A0=A0=A0=A0at ulogd_inppkt_NFLOG.c:483
> =A0#11 0x00007f430e20a307 in __nflog_rcv_pkt (nlh=3D<optimized out>,
> nfa=3D<optimized out>,
> =A0=A0=A0=A0=A0data=3D<optimized out>) at libnetfilter_log.c:160
> =A0#12 0x00007f430e0056b7 in __nfnl_handle_msg (len=3D268,
> nlh=3D0x7f430efe2010, h=3D0x74e8e0)
> =A0=A0=A0=A0=A0at libnfnetlink.c:1236
> =A0#13 nfnl_handle_packet (h=3D0x74e8e0, buf=3D0x7f430efe2010 "\f\001=
",
> len=3D<optimized out>)
> =A0=A0=A0=A0=A0at libnfnetlink.c:1256
> =A0#14 0x00007f430e20a508 in nflog_handle_packet (h=3D<optimized out>=
,
> buf=3D<optimized out>,
> =A0=A0=A0=A0=A0len=3D<optimized out>) at libnetfilter_log.c:323
> =A0#15 0x00007f430e40eaed in nful_read_cb (fd=3D<optimized out>,
> what=3D<optimized out>,
> =A0=A0=A0=A0=A0param=3D0x74a6b0) at ulogd_inppkt_NFLOG.c:463
> =A0#16 0x0000000000404ee0 in ulogd_select_main ()
> =A0#17 0x0000000000402b17 in main ()
>=20
> Signed-off-by: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>
> ---
> =A0src/ulogd.c | 132
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
> =A01 file changed, 125 insertions(+), 7 deletions(-)
>=20
> diff --git a/src/ulogd.c b/src/ulogd.c
> index 958c30a..4c76e43 100644
> --- a/src/ulogd.c
> +++ b/src/ulogd.c
> @@ -90,6 +90,29 @@ static int info_mode =3D 0;
> =A0static int verbose =3D 0;
> =A0static int created_pidfile =3D 0;
> =A0
> +/*
> + * Using self-pipe trick to handle signals safely.
> + * (To avoid calling Async-Signal-Unsafe functions in signal
> handler.)
> + *
> + * cf. https://lwn.net/Articles/177897/
> + *=A0
> + * Capacity of pipe(2) buffer is >=3D 4096.
> + */
> +static int signal_channel[2] =3D { -1, -1 };	/* initialize with
> invalid fd */
> +#define	SIGNAL_RX_FD	(signal_channel[0])	/*
> main thread select() this fd */
> +#define	SIGNAL_TX_FD	(signal_channel[1])	/*
> signal handler writes to this fd */
> +
> +static void signal_handler(int signal);
> +static void sigterm_handler_task(int signal);
> +static void signal_handler_task(int signal);
> +
> +static int=A0=A0signal_channel_callback(int fd, unsigned int what, v=
oid
> *data);
> +static struct ulogd_fd	signal_channel_ulogfd =3D {
> +	.when =3D ULOGD_FD_READ,
> +	.cb =3D &signal_channel_callback,
> +	.data =3D &signal_channel_ulogfd,
> +};
> +
> =A0/* linked list for all registered plugins */
> =A0static LLIST_HEAD(ulogd_plugins);
> =A0/* linked list for all plugins handle */
> @@ -387,6 +410,80 @@ void ulogd_register_plugin(struct ulogd_plugin
> *me)
> =A0}
> =A0
> =A0/*****************************************************************=
**
> ****
> + * UTILITY FUNCTIONS FOR SIGNAL HANDLING
> +
> *********************************************************************
> **/
> +static void call_signal_handler_tasks(int sig)
> +{
> +	/* Deliver signals */
> +	switch (sig) {
> +	case SIGTERM:
> +	case SIGINT:
> +		sigterm_handler_task(sig);
> +		break;
> +	case SIGHUP:
> +	case SIGALRM:
> +	case SIGUSR1:
> +	case SIGUSR2:
> +		signal_handler_task(sig);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static int signal_channel_callback(int fd, unsigned int what, void
> *data)
> +{
> +	int	ret;
> +	unsigned char c;
> +
> +	while ((ret =3D read(fd, &c, 1)) > 0) {
> +		call_signal_handler_tasks((int)c);
> +	}
> +	return 0;
> +}
> +
> +static int create_signal_channel(void)
> +{
> +	int	ret;
> +	long	flags;
> +
> +	if ((ret =3D pipe(signal_channel)) < 0)
> +		return ret;
> +
> +	/* SIGNAL_RX_FD, channel[0] */
> +	if ((flags =3D fcntl(SIGNAL_RX_FD, F_GETFL)) < 0)
> +		goto err_exit;
> +	flags |=3D O_NONBLOCK;
> +	if ( fcntl(SIGNAL_RX_FD, F_SETFL, flags) < 0 )
> +		goto err_exit;
> +
> +	/* SIGNAL_TX_FD, channel[1] */
> +	if ((flags =3D fcntl(SIGNAL_TX_FD, F_GETFL)) < 0)
> +		goto err_exit;
> +	flags |=3D O_NONBLOCK;
> +	if ( fcntl(SIGNAL_TX_FD, F_SETFL, flags) < 0 )
> +		goto err_exit;
> +
> +	/* register SIGNAL_RX_FD to ulogd */
> +	signal_channel_ulogfd.fd =3D SIGNAL_RX_FD;
> +	ulogd_register_fd(&signal_channel_ulogfd);
> +
> +	return 0;
> +
> +err_exit:
> +	if (SIGNAL_RX_FD >=3D 0) {
> +		(void)close(SIGNAL_RX_FD);
> +		SIGNAL_RX_FD =3D -1;
> +	}
> +	if (SIGNAL_TX_FD >=3D 0) {
> +		(void)close(SIGNAL_TX_FD);
> +		SIGNAL_TX_FD =3D -1;
> +	}
> +	return -1;
> +}
> +
> +
> +/*******************************************************************
> ****
> =A0 * MAIN PROGRAM
> =A0
> *********************************************************************
> **/
> =A0
> @@ -925,7 +1022,6 @@ static void ulogd_main_loop(void)
> =A0	struct timeval *next =3D NULL;
> =A0
> =A0	while (1) {
> -		/* XXX: signal blocking? */
> =A0		if (next !=3D NULL && !timerisset(next))
> =A0			next =3D ulogd_do_timer_run(&next_alarm);
> =A0		else
> @@ -1225,7 +1321,19 @@ static void stop_stack()
> =A0}
> =A0
> =A0
> -static void sigterm_handler(int signal)
> +/* This is a real SIGTERM, SIGINT, SIGHUP, SIGALRM, SIGUSR1, SIGUSR2
> handler */
> +static void signal_handler(int signal)
> +{
> +	unsigned char	c =3D (unsigned char)signal;
> +
> +	(void)write(SIGNAL_TX_FD, &c, 1);
> +}
> +
> +/* This is NOT a real signal handler.
> + * It is called in ulogd_main_loop() to avoid
> + * calling Async-Signal-UnSafe functions in signal handler.
> + */
> +static void sigterm_handler_task(int signal)
> =A0{
> =A0
> =A0	ulogd_log(ULOGD_NOTICE, "Terminal signal received,
> exiting\n");
> @@ -1255,7 +1363,12 @@ static void sigterm_handler(int signal)
> =A0	exit(0);
> =A0}
> =A0
> -static void signal_handler(int signal)
> +
> +/* This is NOT a real signal handler.
> + * It is called in ulogd_main_loop() to avoid
> + * calling Async-Signal-UnSafe functions in signal handler.
> + */
> +static void signal_handler_task(int signal)
> =A0{
> =A0	ulogd_log(ULOGD_NOTICE, "signal received, calling
> pluginstances\n");
> =A0=09
> @@ -1269,7 +1382,7 @@ static void signal_handler(int signal)
> =A0				fprintf(stderr,=A0
> =A0					"ERROR: can't open logfile
> %s: %s\n",=A0
> =A0					ulogd_logfile,
> strerror(errno));
> -				sigterm_handler(signal);
> +				sigterm_handler_task(signal);
> =A0			}
> =A0=09
> =A0		}
> @@ -1464,8 +1577,13 @@ int main(int argc, char* argv[])
> =A0		}
> =A0	}
> =A0
> -	signal(SIGTERM, &sigterm_handler);
> -	signal(SIGINT, &sigterm_handler);
> +	if (create_signal_channel() < 0) {
> +		ulogd_log(ULOGD_FATAL, "can't create signal
> channel\n");
> +		warn_and_exit(daemonize);
> +	}
> +
> +	signal(SIGTERM, &signal_handler);
> +	signal(SIGINT, &signal_handler);
> =A0	signal(SIGHUP, &signal_handler);
> =A0	signal(SIGALRM, &signal_handler);
> =A0	signal(SIGUSR1, &signal_handler);
> @@ -1477,6 +1595,6 @@ int main(int argc, char* argv[])
> =A0	ulogd_main_loop();
> =A0
> =A0	/* hackish, but result is the same */
> -	sigterm_handler(SIGTERM);=09
> +	sigterm_handler_task(SIGTERM);=09
> =A0	return(0);
> =A0}
--=20
Eric Leblond <eric@regit.org>


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
