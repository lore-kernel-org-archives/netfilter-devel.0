From: Ozgur Akan <akan@aiqa.com>
Subject: Re: chain_cache
Date: Fri, 21 May 2004 09:33:26 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40ADA2B6.3040107@aiqa.com>
References: <Pine.LNX.4.44.0405201705320.7143-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405201705320.7143-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Henrik Nordstrom wrote:

>The task you are amiming at (detect duplicate rules) purely involves
>modifying libiptc and requires a reasonable understanding of libiptc as 
>you need to find the previous rule when inserting a new rule.. This is 
>unfortunately not as easy as it may sound as the rules is managed in-place 
>in their binary format and all you have is the offset where the new rule 
>should be inserted.
>

Yes after some study I understand that libiptc needs to be modified. 
When a rule is modified, deleted, appended or inserted we have to check 
the previous and next rule in the chain. (Of course for the first rule 
there will be no previous rule and for the last there will be no next 
rule, so append and insert 1 are easier to check)

>
>The best place for to detect this is probably TC_INSERT_ENTRY. There you 
>have a somewhat reasonable view of the chain in question and access to the 
>binary rule representations.
>  
>
What I think to do is to write a function to check previous and next 
rule. It may get an argument of -1 to check previous rule, 1 to check 
next rule and 0 to check both.

Also it may be a patch for insert_rules. insert_rules is used in all 
rule manuplation functions in libiptc.

I have not decided yet which solution will be the best but I am about to 
find it...

thank you for your comments.

regards,

-- 
Ozgur Akan
