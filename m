From: Patrick McHardy <kaber@trash.net>
Subject: Re: does ipset conflict with ipsec SuSE kernel patch?
Date: Sat, 08 Jul 2006 05:06:03 +0200
Message-ID: <44AF211B.1040504@trash.net>
References: <8812D8156467224C9E9739E513037EF1F3FD47@moe.nextone.local>
	<44AE63F1.1020707@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44AE63F1.1020707@ufomechanic.net>
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
>>Does this mean IPsec conflicts with ipsets?  The comment of SuSE kernel
>>patch said the patches are from netfilter team, and the ipsets are also
>>from netfilter.org.  Since they are both belong to netfilter team, is
>>there any way to resolve the conflict?
>>
>>Please let me know if you need more information.  Thanks for your time.


As far as I know SuSE chose to use an extremly beta (and horribly outdated
and incompatible to what we have today) version of my IPsec patches.
They have lots of known bugs, and SuSE certainly made a poor decision
(after buggering me for weeks) here. Please take it on with their
support or use the vanilla kernel.
