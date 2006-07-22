From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] priv_data 0/2
Date: Sat, 22 Jul 2006 15:34:45 +0200
Message-ID: <44C22975.5050504@trash.net>
References: <200606261641.47294.max@nucleus.it>	<44A962DF.3080406@trash.net>	<200607032305.06581.max@nucleus.it>	<44A9A103.8090705@anduras.de>
	<44A9B458.1030106@trash.net> <44C0A3CF.9020702@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44C0A3CF.9020702@ufomechanic.net>
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

Amin Azez wrote:
> * Patrick McHardy wrote, On 04/07/06 01:20:
> 
>>Sven Anders wrote:
>>
>>>If this is merged, I would like to see a negated limit...
>>>I need some advice to preserve compatibility here.
>>
>>Once this is merged we can convert matches and targets to keep their
>>private state outside of the structure shared with userspace and can
>>start reusing the fields, since they are ignored by userspace anyway.
>>I'm not sure, but I think currently userspace initializes them to 0,
>>which should make this easy.
> 
> 
> Relying on userspace to initialize kernel structures to 0 smells like
> danger, and a possible exploit point.

There is no difference here to a million other spots in the kernel.
If something can create trouble, it needs to be verified. In the
case of negation it just means "0 - don't negate", "1 - negate",
and the fact that it used to be 0 can be used to provide backwards
compatibility without introducing a new revision.


BTW, can you please fix your mailer so every mail doesn't go to the
list twice?
