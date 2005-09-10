From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Fix wrong order in event notification
Date: Sat, 10 Sep 2005 18:06:16 +0200
Message-ID: <43230478.7030701@eurodev.net>
References: <42F2B4F4.2080604@eurodev.net> <4321B575.4040009@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <4321B575.4040009@ufomechanic.net>
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

Hi Sam,

Amin Azez wrote:
> I want to "backport" this patch to 2.6.11.7 (before IPS_DYING was
> invented to help shrink the conntrack struct)
> 
> The obvious fixup is below, I just wanted to check that it was safe, and
> that sending the event earlier instead of during death by timeout wasn't
> also depending on side effects of IPS_DYING

ctnetlink is already in the Linus tree, so it will be out in the next
kernel release. Because of that, I don't think that it's worth applying
that patch to the event API in pom-ng. We should focus on what is in
mainline.

--
Pablo
