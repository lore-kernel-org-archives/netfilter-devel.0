From: Kiran Kumar <immidi_kiran@yahoo.com>
Subject: Re: [error] sctp-conntrack-nat [long]
Date: Tue, 20 Apr 2004 20:52:24 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040421035224.85837.qmail@web14007.mail.yahoo.com>
References: <4083C4BF.6030400@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1087061599-1082519544=:85433"
Cc: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>,
  Netfilter developmnet mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4083C4BF.6030400@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--0-1087061599-1082519544=:85433
Content-Type: text/plain; charset=us-ascii
Content-Id: 
Content-Disposition: inline

Hi,
  I had sent the whole stuff
(sctp-conntrack-nat.tar.gz) as a zipped tar file.
Somehow, the include/ directory seems to have got
missed. Am sending the include.tar.gz.. Thanks

--- Patrick McHardy <kaber@trash.net> wrote:
> The include directory is missing from pom-ng. Kiran,
> I couldn't find the
> patch in the archives, could you please send me the
> patch or just the
> contents of include/ required for sctp conntrack ?
> Thanks.
> 
> Regards
> Patrick
> 
> 
> Wojciech 'Sas' Cieciwa wrote:
> > I try to build this module on 2.6.6-rc1 and got
> error:
> > [pom-ng - from CVS date 20040419]
> > 
> >   CC [M] 
> net/ipv4/netfilter/ip_conntrack_proto_sctp.o
> > net/ipv4/netfilter/ip_conntrack_proto_sctp.c:117:
> error: `SCTP_CONNTRACK_MAX' undeclared here (not in
> a function)
> > net/ipv4/netfilter/ip_conntrack_proto_sctp.c:118:
> warning: braces around scalar initializer
> > net/ipv4/netfilter/ip_conntrack_proto_sctp.c:118:
> warning: (near initialization for `sctp_conntracks')

=====
Regards,
Kiran Kumar Immidi


	
		
__________________________________
Do you Yahoo!?
Yahoo! Photos: High-quality 4x6 digital prints for 25¢
http://photos.yahoo.com/ph/print_splash
--0-1087061599-1082519544=:85433
Content-Type: application/x-gzip; name="include.tar.gz"
Content-Transfer-Encoding: base64
Content-Description: include.tar.gz
Content-Disposition: attachment; filename="include.tar.gz"

H4sIAGPohUAAA+2WX2/aMBTFeSWfwhJv1QS28++BaRILkUDtkopk6qRpsqLE
FGvUoOCgSVO/+5wIyra6UKrCNu3+HpLgm2snOefICJnPq4L3WicEYwf7rqvP
Db+fm2uCse1T7HpEjxNCfLeF3FM+1JZqpbISoVa5WKh99x2q/6OIjf5zIatv
J3LBUfpjR+tPbdsH/c/Br/pLrqZirnjJxHLtvJYdnq2/59iuQ7T+ro1t0P8c
7NVfLFm+kFKVWf61O+vOs6J4yRpYi+s5zpP6E3ebf9vFvt/ClGCq9cev/bIm
/nP9OxsDoLcHHcBEfrfszt5Zx/SsctX0/On3BMw8O/8bJV+yxqH8+/rP3nb/
d7FX5594GPJ/DjpiKgs+RWx8zYI4itLJILhkSZBes5HV0RUhubnYu0D1FWrc
IeRtF130LIvL6g7VVtk5B3232k3PbooojsI3j0aDqzgJh4bxOL4ch+xmME6f
LIbBKDb1hkk6eH81TkamYjL6mA7jm4glYWSY+qE8CYN93c0P4wwfBp+s+75l
rVRZ5QrVeVJNkCz9TUyfSptRcd3QrpiQyqZMobXKbj/XAqRsOJ7UU37p/1xX
pnq9aIfLQkyR1smkX61W6/j9n9HjPXZw/yfkIf+U0jr/lHqQ/3PQ1vYQcsVL
hXYuXJYLtdBHsdZuREWmMjTjJa8t035k5cbCfdjgAQAAAAAAAAAAAAAAAAAA
AODv4QdxjHM+ACgAAA==

--0-1087061599-1082519544=:85433--
