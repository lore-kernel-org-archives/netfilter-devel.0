From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re[3]: REJECT target
Date: Thu, 26 Jun 2003 16:56:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1012141349.20030626165642@habitat-b.de>
References: <Pine.LNX.4.33.0306260830550.10452-100000@blackhole.kfki.hu>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.33.0306260830550.10452-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Jozsef, list,

Okay, admitted. I would be glad to do that in the filtering table, the
question is: How can I identify those packets, when the were modified
in the nat table ?

Assuming I have a subnet and a cluster of ip addresses, which get
redirected in the PREROUTING chain. since the destination address is
getting changed, how can I now reject some of those packets, when they
are meant for certain hosts/networks. So, what I want to do, redirect
packets, but those send to certain destination, or which were meant
for certain destinations should be rejected. I don't want them to just
be dropped (without further notice).

In the current design I can't see any way, to do such a thing, that's
why I wanted to reject them in nat(PREROUTING).

Any thoughts on that ?

Sorry for bothering again ...

-Sven

Thursday, June 26, 2003, 8:40:22 AM, you wrote:

JK> Hi,

JK> On Wed, 25 Jun 2003, DarKRaveR wrote:

>> I understood that, the question is why ? I got a scenarion, where I
>> would need it in the PREROUTING chain of the nat table, instead of
>> just dropping the packets ... Is there any reason, why it is only
>> available in the filter table. I mean, it's for filtering okay, but
>> maybe I want to reject connections properly at other places (like nat
>> table, prerouting) instead of plain stupid
>> dropping them and waiting at the client software to time out.

JK> Thy users of netfilter do not filter packets in the nat or mangle tables.

JK> [Check out the mailing list archive and the documentation if you do not
JK> know why. We discussed it countless times.]

JK> Best regards,
JK> Jozsef
JK> -
JK> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
JK> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
JK> Address : KFKI Research Institute for Particle and Nuclear Physics
JK>           H-1525 Budapest 114, POB. 49, Hungary




-- 
Best regards,
 DarKRaveR                            mailto:DarKRaveR@habitat-b.de
