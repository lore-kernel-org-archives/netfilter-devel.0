From: Glauber Reis <greis_one@yahoo.com.br>
Subject: pkttables compilation problem
Date: 16 Jan 2004 09:40:26 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1074256826.6677.9.camel@oc-cinf-lin>
Reply-To: greis_one@yahoo.com.br
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Is pkttables from CVS broken? Is there any requisites?
I got only NETLINK and nfnetlink-ctnetlink-0.13 into a 2.4.22 kernel
(from kernel.org).
I'd really want to try a netfilter userspace library, but got no success
with libiptc...
Any suggestion?

When I issue a make I get the following

Making all in .
make[1]: Entering directory `/opt/prog/Netfilter/pkttables'
make[1]: Nothing to be done for `all-am'.
make[1]: Leaving directory `/opt/prog/Netfilter/pkttables'
Making all in include
make[1]: Entering directory `/opt/prog/Netfilter/pkttables/include'
make  all-am
make[2]: Entering directory `/opt/prog/Netfilter/pkttables/include'
make[2]: Nothing to be done for `all-am'.
make[2]: Leaving directory `/opt/prog/Netfilter/pkttables/include'
make[1]: Leaving directory `/opt/prog/Netfilter/pkttables/include'
Making all in libnfnetlink
make[1]: Entering directory `/opt/prog/Netfilter/pkttables/libnfnetlink'
/bin/sh ./config.status --recheck
./config.status: ./config.status: No such file or directory
make[1]: *** [config.status] Error 127
make[1]: Leaving directory `/opt/prog/Netfilter/pkttables/libnfnetlink'
make: *** [all-recursive] Error 1
