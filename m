From: Samuel Liddicott <sliddicott@dbamsystems.com>
Subject: Re: nfnetlink/ctnetlink from pom-ng r3884
Date: Wed, 20 Apr 2005 15:17:48 +0100
Message-ID: <4266648C.3030507@dbamsystems.com>
References: <20050419212858.039E.LARK@linux.net.cn>
	<42665BF9.9090707@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42665BF9.9090707@ufomechanic.net>
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


OK, I think this was my fault due to bad use of printk and 64 bit numbers.

I used to think that printk/printf pushed a pointer to the number to the 
stack, it seems to push the actual value to the stack, and I wasn't 
properly specifying in my format string that it was a 64 bit number, so 
the most significant 4 bytes were being used as the next argument.

This was shown by outputting only one value per printk statement.

Apologies all.

Amin
