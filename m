From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6 0/12]: netfilter update
Date: Wed, 22 Sep 2004 01:38:10 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4150BB62.2060904@trash.net>
References: <414F9DFC.701@trash.net> <20040921143611.6a6e2f60.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20040921143611.6a6e2f60.davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

David S. Miller wrote:

>On Tue, 21 Sep 2004 05:20:28 +0200
>Patrick McHardy <kaber@trash.net> wrote:
>
>  
>
>>following are 12 mostly random netfilter patches for 2.6.
>>You can also pull all changes from bk://212.42.230.204/2.6-netfilter
>>    
>>
>
>There are big conflicts with Rusty's recent
>seq file fixes to ip_conntrack_standalone.c
>
>Please resync with Linus's current tree and
>use "bk resolve" or whatever means to fix this
>up.
>  
>

Done. The updated tree is at the same location.

Regards
Patrick
