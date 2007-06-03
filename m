From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Sun, 3 Jun 2007 19:29:25 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706031927500.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>
	<465CA950.403@trash.net> <4661687F.6040302@trash.net>
	<200706031047.44848.dim@openvz.org> <4662F2E9.1090903@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dmitry Mishin <dim@openvz.org>, sparclinux@vger.kernel.org,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4662F2E9.1090903@trash.net>
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


On Jun 3 2007 18:57, Patrick McHardy wrote:
>Dmitry Mishin wrote:
>> On Saturday 02 June 2007 16:54, Patrick McHardy wrote:
>> 
>>>Here it is, could you please test whether it fixes the crash by
>>>backing out the hashlimit compat patch and triggering the size
>>>error again? Thanks.
>> 
>> Patrick, 
>> it looks like translate_compat_table() should be fixed also.
>
>You're right, thanks for catching this. This patch should be
>better.

I am kind of impartial when it comes to testing patches, but when
I look through and want to reply to them, doing them inline is
preferred.

Tested-By: Jan Engelhardt <jengelh@gmx.de>



	Jan
-- 
