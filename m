From: Eric Leblond <eric@inl.fr>
Subject: Bug in conntrack -U
Date: Fri, 01 Jun 2007 16:17:13 +0200
Message-ID: <1180707433.4733.7.camel@ghlodit.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

I've found a problem with conntrack-tools. Running :
conntrack -U -m 20 -s 192.168.50.140 -d 192.168.50.129 -p tcp --orig-port-src 43515 --orig-port-dst 22
returns
Operation failed: invalid parameters

Problem has been verified with kernel 2.6.20 and 2.6.17 with subversion
compiled libraries and conntrack-tools on 32bits and 64bits system. I
did not find the time to test it on latest kernel.

BR,
-- 
Eric Leblond <eric@inl.fr>
INL SARL
