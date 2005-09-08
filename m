From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH 2.4] Introducing Bidirectional conntrack mark
Date: Thu, 8 Sep 2005 18:10:10 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0509081801100.21201@filer.marasystems.com>
References: <002601c5b390$1d641d10$fefefe0a@jesseh7ht76e8n>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesse Peng <Jesse@deansoft.com.tw>
In-Reply-To: <002601c5b390$1d641d10$fefefe0a@jesseh7ht76e8n>
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

On Wed, 7 Sep 2005, Jesse Peng wrote:

> Greetings all,
> This patch fully derive from Henrik Nordstrom's long known connmark patch but is extended to bidirectional solution.
> The solution once discussed as the following link:
> https://lists.netfilter.org/pipermail/netfilter-devel/2005-March/018784.html
>
>
> Dear Henrik:
> Feel free to give any advice for the work extending your existing famous connmark patch.
>
> Dear Jian:
> I got approved for quite a period,but sorry for this late posting this patch after a busy season.Hope this help!


Patch seems incomplete. Can not find definition of conntrack->dir_mark

Also as before I still wonder if this relatively big amount of info in 
each conntrack is really needed. CONNMARK already declares 32 bits per 
conntrack entry free for any use. Perhaps better to extend CONNMARK with 
shifting of the value allowing simple save/restore operations based on 
direction (where directions is selected by the already existing conntrack 
match).

But I do fully agree with the principle of being able to intelligenly keep 
conntrack state information/mark direction dependent and that having just 
a simple masking of the value is perhaps not sufficient in all situations.

Regards
Henrik
