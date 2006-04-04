From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch-o-matic cleanup
Date: Tue, 04 Apr 2006 10:38:04 +0200
Message-ID: <4432306C.10106@trash.net>
References: <443165AA.4030509@trash.net> <44321188.30902@hivemynd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Jones <hivemynd@hivemynd.net>
In-Reply-To: <44321188.30902@hivemynd.net>
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

Stephen Jones wrote:
> Patrick McHardy wrote:
> 
>> - pptp-conntrack-nat: in mainline now, patches are missing critical
>>   fixes
> 
> Hi Patrick,
> 
> Is pptp-conntrack-nat functionality going to be included in the 2.4.x
> mainline also?  Otherwise, the patches still appear to be necessary for
> 2.4.x kernels.

No, 2.4 is in absolute stable mode. The pptp patches for 2.4 are missing
a number of important bugfixes, I wouldn't recommend using them in their
present form. We don't have the time to maintain old versions forever,
which is why we decided to remove this old stuff.
