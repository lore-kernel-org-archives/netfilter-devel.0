From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: CLASSIFY target in POSTROUTING only?
Date: Fri, 04 Mar 2005 13:30:21 +0200
Message-ID: <422846CD.30105@outerspace.dyndns.org>
References: <20050304112306.29481.qmail@web90007.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Peter Lenci <peterlenci@yahoo.ca>
In-Reply-To: <20050304112306.29481.qmail@web90007.mail.scd.yahoo.com>
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

Peter Lenci wrote:

| Hi all

Hello there :)

| The CLASSIFY extension can only be used in the POSTROUTING chain of the
| mangle table. Is there a technical reason for this or is it just an aid
| to prevent misconfiguration? In particular I'd like to use the CLASSIFY
| target in the PREROUTING table (in combination with ingress tcp shaping
| with the IMQ device).

If you do the shaping on the IMQ device, I think you can do the shaping
in POSTROUTING, since the ingress shaping is done in the "egress" part
of the IMQ device anyway. You may have to configure the "AA AB BA BB"
IMQ setting in menuconfig for it to work though. If you can't figure it
out, I can try looking into it myself later when I have better time.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCKEbFxyF48ZTvn+4RAu0jAJ9x99KPsNdNiJVMsDIE1vQGMsG5jQCeMeTP
mq61NBECGpTwJUo84vTXCc8=
=qSJP
-----END PGP SIGNATURE-----
