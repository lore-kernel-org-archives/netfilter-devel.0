From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Orphaned expectations
Date: Thu, 22 Apr 2004 00:54:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4086FB97.9020902@eurodev.net>
References: <Pine.LNX.4.44.0404211215030.726-100000@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>,
 Phil Oester <kernel@linuxace.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0404211215030.726-100000@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Chris,

Chris Wilson wrote:

>>So now, with only an udp packet, we have a conntrack which is not 
>>confirmed with an expectation associated, and as Phil pointed out, if 
>>this conntrack is destroyed the expectation keeps there forever.
>>    
>>
>
>Thanks very much for your explanation. So, to prevent this from happening, 
>what is the best thing to do?
>
>1. Audit all helpers to check that they don't create expectations to 
>unconfirmed conntracks
>  
>

I think that this assumption is wrong for udp based helpers. When 
connection tracking sees udp packet which has a helper associated for 
first time, a conntrack (not confirmed yet) and its respective 
expectation are created, and surely this conntrack will be confirmed later.

>2. Modify destroy_conntrack to destroy any associated expectations, 
>whether or not the conntrack is confirmed (presumably right now it only 
>does so if the conntrack is confirmed? hence the problem?)
>  
>

yes, I think that Phil's solution is ok, this could also prevent any 
other weird combinations.

regards,
Pablo
