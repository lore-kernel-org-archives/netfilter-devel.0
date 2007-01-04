From: Victor Stinner <victor.stinner@inl.fr>
Subject: Conntrack and IPv6
Date: Thu, 4 Jan 2007 14:52:25 +0100
Message-ID: <200701041452.25119.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

To test my Python binding, I tried to dump conntrack table for IPv6 protocol 
but I just get the error "Address family not supported by protocol".

I tried old libnetfilter_conntrack API and I don't get error. But I can't see 
my connections (whereas "netstat --protocol inet6" lists them).

Do I need a kernel newer than 2.6.17? Or netfilter conntrack doesn't support 
IPv6?

For my tests, I used a ssh connection to ipv6-localhost ("ssh ::1").

Victor Stinner
http://www.inl.fr/
