From: Patrick McHardy <kaber@trash.net>
Subject: Re: CLASSIFY target
Date: Tue, 30 May 2006 21:40:34 +0200
Message-ID: <447C9FB2.20604@trash.net>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB2553FA@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
In-Reply-To: <0633E0EDB4F25F43A2D7179CA11FAFAB2553FA@xavier.staff.greatlakes.net>
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

Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> Thank you for your response. I did manage to finally find the code I was
> looking for. I also just posted a new description to LARTC with a new
> class/qdisc layout. Essentially, what I have now is:
> 
> dev wivl4 HFSC Qdisc root
>   |
>   |-> HFSC Class
>   |
>   |-> HFSC Class
>   ...etc...
> 
> And I'm doing a classify directly to those classes. They have no sub
> qdiscs or sub classes. Yet, it still will not work. Any additional
> thoughts?

No, please show the classids and commands uses.
