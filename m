From: Klaus Ethgen <Klaus+lkml@ethgen.de>
Subject: conntrack_ftp and DNAT
Date: Sat, 11 Feb 2017 23:05:44 +0100
Message-ID: <20170211220544.qe3tvfrrisllesix@ikki.ethgen.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; x-action=pgp-signed
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tschil.ethgen.ch ([5.9.7.51]:58350 "EHLO tschil.ethgen.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750867AbdBKW0H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Feb 2017 17:26:07 -0500
Received: from [192.168.17.4] (helo=ikki.ket)
        by tschil.ethgen.ch with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.88)
        (envelope-from <klaus@ethgen.de>)
        id 1ccfnd-0006KD-DK
        for netfilter-devel@vger.kernel.org; Sat, 11 Feb 2017 23:05:45 +0100
Received: from klaus by ikki.ket with local (Exim 4.89)
        (envelope-from <klaus@ikki.ethgen.ch>)
        id 1ccfnc-0005Sv-N2
        for netfilter-devel@vger.kernel.org; Sat, 11 Feb 2017 23:05:44 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hello,

allow me to ask a question about conntrack and nf_conntrack_ftp and
nf_nat_ftp and DNAT.

I have a host where I do DNAT from the main IPv4 address to the backend
ftp server. Currently I have the server data connections limited to a
small port range and have a hard wired DNAT of that port range to the
ftp server too. But this is not optimal as that port range is not open
for other connections.

I wanted to replace that with conntrack but failed.

Here are the relevant entries in iptables:
iptables -t raw -A PREROUTING -p tcp -m tcp --dport 21 -j CT --helper ftp
iptables -t nat -A PREROUTING -d X.X.X.X/32 -p tcp -m tcp --dport 20:21 -j DNAT --to-destination 10.0.0.3
iptables -t nat -A PREROUTING -d X.X.X.X/32 -p tcp -m tcp --dport 52100:52199 -j DNAT --to-destination 10.0.0.3
iptables -A FORWARD -d 10.0.0.3/32 -o br0 -p tcp -m tcp --dport 52100:52199 -m helper --helper ftp -j ACCEPT
iptables -A FORWARD -d 10.0.0.3/32 -o br0 -p tcp -m tcp --dport 52100:52199 -j ACCEPT

The second last rule never gets any hit (That is the reason for the last
rule).

I inserted several logging rules to see if a package gets conntrack
marked by the ftp helper but for me it seems that this is never the
case.

I have a similar setup on a client firewall where conntrack works well.
(Using MASQUERADE in nat table POSTROUTING.) I checked that and the
packages gets really handled by the ftp helper.

On both systems I loaded nf_conntrack_ftp and nf_nat_ftp kernel module.

I would really like to drop the last rule above and use bigger port
range for the ftp server. But I have no idea what to do to get that
working.

Allow be also to say that this helper stuff is somehow underdocumented
and could be improved a bit more. ;-)

Regards
   Klaus

Ps. On both systems, I use kernel 4.8.15 from devuan.
PPs. Please include me in responses as I am not subscribed to the list.
- -- 
Klaus Ethgen                                       http://www.ethgen.ch/
pub  4096R/4E20AF1C 2011-05-16            Klaus Ethgen <Klaus@Ethgen.ch>
Fingerprint: 85D4 CA42 952C 949B 1753  62B3 79D0 B06F 4E20 AF1C
-----BEGIN PGP SIGNATURE-----
Comment: Charset: ISO-8859-1

iQGzBAEBCgAdFiEEMWF28vh4/UMJJLQEpnwKsYAZ9qwFAlifiq4ACgkQpnwKsYAZ
9qxwUQwAp5K/ln1ErgEIAocb0gyiwlURXFoMJPpmzuJUUn3PDez8AK05uXMLxAVY
zUTRZ6vN3qfWoIeG8pEjGtX9eecKgysBm2Xmt5k9TdkjhuV8Vp3wnZyOiuXgV0NH
B5/FhmLYsAjpXxzwD9EwyLO39+N2qR5ykxlj6aQc282m9fT/Te58A/VrPht2sgiy
lx4bWTVw8SL9Ba+eQRKDyICSD+Dl7kIhJJuU+4vVev0Gx+H3/HyisKeNU15fX+Ux
asgRI0bMVUo+YFZz8uMOhnu8jY5IxGtHXxajivM3ekWlGTS/9y4JBntTfJEi8C5i
8HOvAT0mQRN9EPwSiVANWMU62C21lCc77nE43p4JmrY7ME0iXl7FuXFVqQxETEwR
pRVPOgXr9+KcMXXMHVCZKE6NR00tmQ6xhK4EyS3OmmbTyp900okZC9kBr+Kdzx0s
Ry2PKCA8Ne6KBB77ZIY33TcIhuqn7nNfs/DN59Um39Wp3/rcedfbGNEEd4yb2axD
rZPAaXt7
=N5Ju
-----END PGP SIGNATURE-----
