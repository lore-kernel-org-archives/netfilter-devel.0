From: Martijn Lievaart <m@rtij.nl>
Subject: writing a fragmentation-needed patch
Date: Sat, 29 Mar 2003 18:21:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E85D60D.7040304@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I have written a patch for ipt_REJECT that enables iptables to send back 
fragmentation-needed. This is useful for testing PMTUD problems. It 
works for me now, but needs some polishing before I release it.

Questions:
- Would such a patch have a chance to be submitted to pom?
- If so, where can I find information on how to submit such a patch

If not, I'll just post it to the list and on my website so others can 
still take advantage of it.

BTW, this patch is completely incompatible with the fake-source patch. 
ipt_REJECT would need major surgery to enable both patches. Imo this is 
not a problem (just don't apply both patches), but I'ld like to know how 
others think about this.

Martijn Lievaart
