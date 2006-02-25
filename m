From: Gregor Maier <gregor@net.in.tum.de>
Subject: Re: iptables target for libnetfilter_log
Date: Sat, 25 Feb 2006 14:18:26 +0100
Message-ID: <44005922.30008@net.in.tum.de>
References: <43FF8AA7.6000608@net.in.tum.de> <440017B2.2050504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <440017B2.2050504@trash.net>
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

Patrick McHardy wrote:

> The LOG target uses is as a backend if it is loaded, but this is IMO
> actually a mistake, the LOG target should keep working the same way
> as it always did. Which reminds me that I wanted to restore the old
> way before 2.6.16 is out ..

The LOG target uses the nf_log mechanism and tries to register a logger
to nf_log. Problem is, that userspace apps can unregister this LOG
logger and register the netlink logger.

>>If not I'd write one.
> Mhh maybe we could add a flag to the LOG target to use whatever nf_log
> backend is registered. I'd prefer that to a full new target.
The problem is, that packets that should be logged to syslog take
log-level, log-prefix, log-tcp-sequence, log-tcp-iptions, ... as
parameters, whereas a target for logging to userspace must provide a
group/queuenum and a prefix.

If there's a only one target, the userland iptables must check if the
packet should be queued to userspace or logged to syslog.
If its syslog, then accept log-prefox, log-level, log-tcp-sequence et.
al parameters. If it should be queued to userspace it should only accept
log-prefix and log-group. I think that's awful semantics from a
userspace point of view.

IMHO having the LOG target log directly to syslog and having e.g. NFLOG
log/queue to userspace (as ULOG) is straighter.

Furthermore a new NFLOG target could use xtables.


cu
Gregor
- --
Gregor Maier                                      Lehrstuhl Informatik 8
gregor@net.in.tum.de                              Tel: +49 89  289-18010
http://www.net.in.tum.de                                     TU Muenchen
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEAFiddGiwgbikMYMRAgKNAJ9Ppxlh5ZHAf2gg2SSZSTQf4gZb4QCfQahY
T/3L6Or9LNFY0k4gC5JkoMg=
=irGk
-----END PGP SIGNATURE-----
