From: Juha Heljoranta <juha.heljoranta@evtek.fi>
Subject: Modify skb from match module?
Date: Wed, 16 Feb 2005 23:03:21 +0200
Message-ID: <4213B519.3080201@evtek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

I would like to associate some information to struct sk_buff *skb so 
that it would be available later while processing packet. But it turns 
out that the skb is const

    static int match(const struct sk_buff *skb, ...

Is there any way to modify skb from match module? Or is there another 
way to store/cache information so that it can be later associated to skb.

The information that I'd like to store consist inode and device number 
and some other stuff about the process owning sending/receiving socket. 
Storing this information makes sense because it can be used later (e.g. 
for logging) and fetching it takes time/cpu.

Regards,
Juha Heljoranta
