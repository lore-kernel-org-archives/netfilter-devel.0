From: Alan Ezust <alan.ezust@presinet.com>
Subject: Re: testing installation of conntrack command line tool
Date: Tue, 10 Oct 2006 12:15:41 -0700
Message-ID: <200610101215.42121.alan.ezust@presinet.com>
References: <200610031518.10097.alan.ezust@presinet.com>
	<200610061314.16177.alan.ezust@presinet.com>
	<45279039.8090309@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
In-Reply-To: <45279039.8090309@netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Saturday 07 October 2006 04:32, Pablo Neira Ayuso wrote:
> Alan Ezust wrote:
> > On Thursday 05 October 2006 03:23, Pablo Neira Ayuso wrote:
> >> Alan Ezust wrote:
> >>> On Wednesday 04 October 2006 15:04, Pablo Neira Ayuso wrote:
> >>>> Alan Ezust wrote:
> >>>>> On Wednesday 04 October 2006 12:48, Pablo Neira Ayuso wrote:
> >>>>>> Alan Ezust wrote:
> >>>>>>> Hi - i'm trying out the "conntrack" program for my first time.
> >>>>>>> It compiles and runs, but when I try to do
> >>>>>>>
> >>>>>>> conntrack -L conntrack
> >>>>>>>
> >>>>>>> it shows me nothing.
> >>>>>>>
> >>>>>>> If I cat /proc/net/ip_conntrack I can see lots of log lines there.
> >>>>>>> Should the conntrack -L conntrack show me pretty much the same
> >>>>>>> thing?
> >>>>>>>
> >>>>>>> What's the best way to test that conntrack is working properly?
> >>>>>>
> >>>>>> Please check that ip_conntrack_netlink is loaded, old kernel do not
> >>>>>> load it on demand.
> >>>>>
> >>>>> I'm using kernel 2.6.16.29.
> >>>>>
> >>>>> These kernel options are set:
> >>>>>
> >>>>> CONFIG_NETFILTER_NETLINK=y
> >>>>> CONFIG_NETFILTER_NETLINK_QUEUE=y
> >>>>> CONFIG_NETFILTER_NETLINK_LOG=y
> >>>>> CONFIG_IP_NF_CONNTRACK_NETLINK=y
> >>>>>
> >>>>> Are you saying I should also add a
> >>>>> CONFIG_IP_CONNTRACK_NETLINK flag in the .config  or something else?
> >>>>
> >>>> No, people usually compile ip_conntrack_netlink as module, and I
> >>>> wanted to make sure that the module was loaded (modprobe
> >>>> ip_conntrack_netlink) but since you compiled it built-in.
> >>>
> >>> What's the difference between IP_NF_CONNTRACK_NETLINK and
> >>> IP_CONNTRACK_NETLINK? Are they different modules or is one the new name
> >>> for the other?
> >>
> >> you're referring to the same thing. This problem that you're observing
> >> is freak. Please check that ctnetlink is correctly registered.
> >
> > On my machine, when I do lsmod, here is the list of modules I have
> > loaded:
> >
> > ip_conntrack_netlink    22016  0
> > ip_nat                 14164  1 ip_conntrack_netlink
> > ipt_recent              9836  2
> > ipt_LOG                 5856  4
> > ipt_bin                20772  7
> > iptable_promisc         1376  1
> > ipt_multiport           2112  10
> > iptable_filter          2112  1
> > ip_tables              10816  2 iptable_promisc,iptable_filter
> > xt_conntrack            1856  0
> > xt_CONNMARK             1824  2
> > xt_connmark             1440  2
> > xt_pkttype              1440  1
> > xt_MARK                 2080  0
> > xt_state                1536  4
> > ipt_psd                43588  1
> > ipt_regex               7240  1
> > ipt_DATA                3712  5
> > ip_conntrack           45996  7
> > ip_conntrack_netlink,ip_nat,xt_conntrack,xt_CONNMARK,xt_connmark,xt_state
> >,ipt_DATA tulip                  45152  0
> > eepro100               25776  0
> > 8139too                20352  0
> > 3c59x                  38952  0
> > 8390                    8320  0
> >
> >> # dmesg | grep ctnetlink
> >> ctnetlink v0.90: registering with nfnetlink.
> >
> > Got that - here is my dmesg tail:
> >
> > ip_conntrack version 2.4 (2048 buckets, 16384 max) - 252 bytes per
> > conntrack ipt_regex v0.0.0
> > netfilter PSD loaded - (c) astaro AG
> > ip_conntrack_netlink: Unknown symbol ip_nat_setup_info
> > ip_conntrack_netlink: Unknown symbol ip_nat_proto_put
> > ip_conntrack_netlink: Unknown symbol ip_nat_proto_find_get
>
> It seems that some symbols are unresolved so ip_conntrack_netlink won't
> work. See below.
>
> >> Send me also your .config file just to have more information.
> >
> > attached.
> >
> >>>> Could you tell me what version of conntrack/libnetfilter_conntrac are
> >>>> you using?
> >>>
> >>> conntrack 1.00beta2
> >>> libnetfilter_conntrack-0.0.31/
> >>> libnfnetlink-0.0.16/
> >>
> >> Please, try with an updated version from netfilter's SVN
> >
> > I found an incompatibility in libnfnetlink. Before, I was building on a
> > system that had 2.6.18 on it, and trying to deploy it on a machine that
> > had kernel 2.6.16.29. The executable I built didn't do anything.
> >
> > Now I am compiling on a system that has the same version (2.6.16.29) of
> > the kernel as the destination, I am unable to compile the latest (svn as
> > well as released) versions of libnfnetlink.
> >
> > What is the recommended kernel version I should be using, if I want to
> > get conntrack up and running for my first time? Should I go to 2.6.18 and
> > forget about 2.6.16.29?
>
> lastest includes tons of changes, better upgrade to 2.6.18.
>
> > gcc -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\"
> > -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DPACKAGE=\"libnfnetlink\"
> > -DVERSION=\"0.0.16\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1
> > -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1
> > -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1
> > -DHAVE_UNISTD_H=1 -DHAVE_DLFCN_H=1 -I. -I. -I../include
> > -I/home/ezust/presinet/projects/conntrack/usr/include -fPIC -Wall
> > -I/home/ezust/presinet/projects/conntrack/usr/include
> > -L/home/ezust/presinet/projects/conntrack/usr/lib -MT libnfnetlink.lo -MD
> > -MP -MF .deps/libnfnetlink.Tpo -c
> > libnfnetlink.c  -fPIC -DPIC -o .libs/libnfnetlink.o
> > libnfnetlink.c: In function 'nfnl_listen':
> > libnfnetlink.c:445: error: 'EINTR' undeclared (first use in this
> > function) libnfnetlink.c:445: error: (Each undeclared identifier is
> > reported only once libnfnetlink.c:445: error: for each function it
> > appears in.)
> > libnfnetlink.c:448: error: 'EBADF' undeclared (first use in this
> > function) libnfnetlink.c:450: error: 'EAGAIN' undeclared (first use in
> > this function) libnfnetlink.c: In function 'nfnl_talk':
> > libnfnetlink.c:554: error: 'EINTR' undeclared (first use in this
> > function) libnfnetlink.c: In function 'nfnl_callback_register':
> > libnfnetlink.c:878: error: 'EINVAL' undeclared (first use in this
> > function) libnfnetlink.c: In function 'nfnl_callback_unregister':
> > libnfnetlink.c:888: error: 'EINVAL' undeclared (first use in this
> > function) libnfnetlink.c: In function 'nfnl_check_attributes':
> > libnfnetlink.c:906: error: 'EINVAL' undeclared (first use in this
> > function) make[1]: *** [libnfnetlink.lo] Error 1
> > make[1]: Leaving directory
> > `/home/ezust/presinet/projects/conntrack-1.00beta2/libnfnetlink-0.0.16/sr
> >c'
>
> Is /usr/include/linux/errno.h available in your system?

Yes, but it does not define those symbols. I found them defined in a file 
called "errno-base.h" in include/asm-generic/errno-base.h, but for some 
reason, when I built and installed the kernel, it did not place these files 
into my /usr/include/asm* directories.  

#define	EPERM		 1	/* Operation not permitted */
#define	ENOENT		 2	/* No such file or directory */
#define EINTR            4      /* Interrupted system call */
#define EAGAIN          11      /* Try again */
#define ENOMEM          12      /* Out of memory */
#define EINVAL          22      /* Invalid argument */
#define	EBADF	         9      /* Bad file number */
#define	ENODEV		    19	     /* No such device */
#define	EEXIST		17	/* File exists */

Is there a configure switch or a variable to set that lets me specify which 
kernel source tree to use when building libnfnetlink, libnfconntrack and 
conntrack?

> > thanks again for your help --alan
> >
> >
> > #
> > # IP: Netfilter Configuration
> > #
> > CONFIG_IP_NF_CONNTRACK=m
> > CONFIG_IP_NF_CT_ACCT=y
> > CONFIG_IP_NF_CONNTRACK_MARK=y
> > CONFIG_IP_NF_CONNTRACK_EVENTS=y
> > CONFIG_IP_NF_CONNTRACK_NETLINK=m
>
>                                 ^^^
> You told me that you compiled ip_conntrack_netlink built-in? This
> doesn't match with your previous email... here it appears as module.

You are absolutely correct: when I wrote you the first e-mail, it was compiled  
built-in, and I was running into problems getting it working, so since then I 
rebuilt the kernel and compiled everything possible as a module, since that's 
what IPTABLES seemed to want. So NOW it is a module.

> You forgot to compile built-in NAT support that is required by
> ip_conntrack_netlink.
> I think that the best solution is to rebuild your kernel and include all
> the netfilter netlink subsystems as modules, that will fix your problem.
