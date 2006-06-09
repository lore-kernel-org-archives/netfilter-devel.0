From: Gregor Maier <gregor@net.in.tum.de>
Subject: [RFC] libnfnetlink, libnetfilter_log,
	libnetfilter_queue  error handling
Date: Fri, 09 Jun 2006 18:01:08 +0200
Message-ID: <44899B44.2030605@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,


I noticed that libnfnetlink, libnetfilter_* are currently missing decent
error handling and reporting mechanisms.

libnetfilter_log and libnetfilter_queue define a nflog_errno resp.
nfq_errno but those aren't really used. libnfnetlink uses fprintf for
error handling/reporting.



What do you think about the following suggestions:
* add a nfnl_errno variable
* add #defines for nfnl_errno values also add a nfnl_strerror and a
nfnl_perror function
* add #defines for nflog_errno and nfq_errno and nf{log|q}_strerror and
nf{log|q}_perror functions.

* make nflog_errno and nfq_errno a superset of the nfnl_errnos. E.g. by
defining that error values from 1...N are for nfnl and values above N
are for nfq_errno and nflog_errno.
* nflog_strerror (and nfq_strerror) check if nflog_errno (resp.
nfq_errno) is <= N. If so, they call nfnl_strerror otherwise they handle
the error themselves.

A user of the libnetfilter_{queue|log} only has to use the nfq_strerror
or nflog_strerror (resp. perror) functions without getting in touch with
the libnfnetlink errors. And by making nf{q|log}_errnos a superset of
nfnl_errnos, reporting netlink errors is straightforward.



How this could look like in code:

/**** libnfnetlink ****/
#define   ENFNL_NOERR    0
#define   ENFNL_FOO      1
#define   ENFNL_FOOBAR   2
....
#define   ENFNL_MAXERR   1024



static const char *const nfnl_errlist[] =
{
   "No error",                  /* 0 */
   "Error foo occured",         /* 1 = ENFNL_FOO */
 .....
};

const char *nfnl_strerror(int errnum) {
	static char buf[1024];

	if (errnum >= nfnl_nerr) {
		snprintf(buf, sizeof(buf), "No such nfnetlink error number %d", errnum);
	}
	else {
		strncpy(buf, nfnl_errlist[errnum], sizeof(buf)-1);
      	buf[sizeof(buf)-1] = '\0'; /* terminate if the error was too long */
	}
	return buf;
		
}



void nfnl_perror(const char *s);

static const int nfnl_nerr =  sizeof (nfnl_errlist) / sizeof
(nfnl_errlist[0]);


/*******************************/
/***** libnetfilter_queue *****/
#define   ENFQ_DUMMY    (ENFQ_MAXERR+1)
#define   ENFQ_BLUB     (ENFQ_MAXERR+2)

...
const char *nfq_strerror(int errnum) {
	static char buf[1024];

	if (errnum <= ENFNL_MAXERR) {
		snprintf(buf, sizeof(buf), "%s", nfnl_strerror(errnum));
	}
	else if (errnum >= ENFNL_MAXERR+1+nfq_nerr) {
		snprintf(buf, sizeof(buf), "No such netfilter_queue error number %d",
errnum);
	}
	else {
		strncpy(buf, nfq_errlist[errnum-ENFNL_MAXERR-1], sizeof(buf)-1);
      	buf[sizeof(buf)-1] = '\0'; /* terminate if the error was too long */
	}
	return buf;
		
}




/*******************************/
/***** libnetfilter_log *****/
#define   ENFLOG_FOO      (ENFNL_MAXERR+1)
#define   ENFLOG_BARFOO   (ENFNL_MAXERR+2)

...
const char *nflog_strerror(int errnum) {
	static char buf[1024];

	if (errnum <= ENFNL_MAXERR) {
		snprintf(buf, sizeof(buf), "%s", nfnl_strerror(errnum));
	}
	else if (errnum >= ENFNL_MAXERR+1+nflog_nerr) {
		snprintf(buf, sizeof(buf), "No such netfilter_log error number %d",
errnum);
	}
	else {
		strncpy(buf, nflog_errlist[errnum-ENFNL_MAXERR-1], sizeof(buf)-1);
      	buf[sizeof(buf)-1] = '\0'; /* terminate if the error was too long */
	}
	return buf;
		
}



Comments?

cu
Gregor

- --
Gregor Maier                                      Lehrstuhl Informatik 8
gregor@net.in.tum.de                              Tel: +49 89  289-18010
http://www.net.in.tum.de                                     TU Muenchen
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEiZtEdGiwgbikMYMRAmiWAJ9vKqp5xdOLeI3dZzh8xsMEw+bxWgCgmC0t
lYaGuEyxlMa7Rvma4qhRdbA=
=ZmGE
-----END PGP SIGNATURE-----
