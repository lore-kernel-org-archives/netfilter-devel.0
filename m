From: Simon Lodal <simonl@parknet.dk>
Subject: Re: [PATCH] realm: fix inversion
Date: Wed, 22 Sep 2004 14:32:50 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415170F2.2060506@parknet.dk>
References: <4150D9F8.7060600@parknet.dk> <4150DC31.4050807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4150DC31.4050807@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hmm ... just realized that inversion is generally a mess. Is there any 
kind of consensus on how to handle it, now/future?

There are 3 ways to specify inversion:

! --ip 1.2.3.4
--ip !1.2.3.4
--ip ! 1.2.3.4

None of them are both 1) documented and 2) working. Especially 
iptables-save and iptables-restore rarely works with inversion.

You should probably remove my patch in favor of a better solution for 
all modules.


Simon


Patrick McHardy skrev:
> Simon Lodal wrote:
> 
>>
>> Make '--realm ! id' work as advertised.
>> Make save() output inversion correctly so it can be parsed back in, 
>> and work with iptables-restore and iptables-save.
> 
> 
> 
> Applied, thanks.
