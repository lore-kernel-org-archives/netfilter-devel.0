From: Dave Maietta <dave@qix.net>
Subject: [BUG] psd and recent clash
Date: Sun, 8 Sep 2002 17:09:15 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020908170915.A2692@hell>
Reply-To: dave@qix.net
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

iptables segfaults when the psd and recent match extensions are combined 
in the same rule.  The offending command is:
	iptables -t filter -A INPUT -m psd -m recent --set -j DROP

I'm using kernel 2.4.20-pre5-ac1, iptables 1.2.7a-20020907, patch-o-matic 
20020825.

Thanks,

Dave Maietta
North Orchard Cr #4-60
Westland MI 48186
734-326-3059 
