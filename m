From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: Patch-o-matic cleanup
Date: Tue, 04 Apr 2006 11:19:27 +0200
Message-ID: <44323A1F.3010803@gmx.net>
References: <443165AA.4030509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <443165AA.4030509@trash.net>
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

Hi,

Patrick McHardy schrieb:
> If noone can name good reasons against it, I will also remove the
> following patches in a few days:
> 
> - unclean: bad idea

Please leave that one in. I know it's a bad idea, but in non-production
setups LOGging all packets matched by unclean gives interesting insights
into network traffic. So it's a valuable educational tool.



Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
