From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ctnetlink & helper_locking_fix conflict
Date: Wed, 10 Nov 2004 19:45:28 +0100
Message-ID: <419261C8.2010707@eurodev.net>
References: <Pine.LNX.4.61.0411090808200.30695@filer.marasystems.com>
	<20041109171106.GF22257@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041109171106.GF22257@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>On Tue, Nov 09, 2004 at 08:13:33AM +0100, Henrik Nordstrom wrote:
>  
>
>>Hi,
>>
>>there is a conflict between the above two patches. The helper_locking_fix 
>>removes the locks from the helpers, but ctnetlink adds code using these 
>>locks.
>>
>>>From reading the code I think the helper side locking should be removed 
>>from the ctnetlink additions as well, but just wanted to verify with you.
>>    
>>
>
>I think it is safe.  We're holding a write lock on ip_conntrack_lock and
>thus it's safe to change the helper data.
>
>If you have a fix for ctnetlink, that would be appreciated
>  
>

I think that there's a minor race. In ip_conntrack_in()

855                 ret = ct->helper->help(*pskb, ct, ctinfo)

This call isn't in a locked section. Someone could be calling the helper 
at the same time that ctnetlink is modifying the private helper info. 
I've annotated this issue since I'll be working in that code (change 
API) once I've done with the event stuff.

Pablo
