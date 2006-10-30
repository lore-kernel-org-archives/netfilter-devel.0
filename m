From: Amin Azez <azez@ufomechanic.net>
Subject: Re: connbytes & 64bit counters
Date: Mon, 30 Oct 2006 12:01:52 +0000
Message-ID: <4545E9B0.40607@ufomechanic.net>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>	<453FE325.1040502@trash.net>
	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
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

* Krzysztof Oledzki wrote, On 28/10/06 17:48:
> On Thu, 26 Oct 2006, Patrick McHardy wrote:
>> It was changed to save some memory in struct ip_conntrack.
>> The idea was mainly that its only used for ctnetlink and
>> it is possible to send events before overflow. Obviously,
>> this wasn't true (besides the fact that events are unreliable).
>> Not sure what we should do about it ..
> 
> How about attached (and inlined for easy review) patch?

I prefer 64 bit counters and am going to have to put them back; so
thanks for this.

Sam
