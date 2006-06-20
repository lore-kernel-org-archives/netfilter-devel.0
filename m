From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Specify nf_queue max length from userspace
Date: Tue, 20 Jun 2006 03:21:29 +0200
Message-ID: <44974D99.8000807@trash.net>
References: <1150217788.7164.4.camel@porky> <1150218404.5386.2.camel@porky>	
	<4496D030.1010400@trash.net> <1150747030.6979.6.camel@porky>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1150747030.6979.6.camel@porky>
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

Eric Leblond wrote:
> I did not like the idea of having params split between two structures.
> And as the user base is still small, I thought we may break ABI to have
> something cleaner.
> Pablo and you do not like the idea, I wrote a patch that should not
> break the ABI (attached to the mail).
> In fact, after introducing the new attribute, I just found it is in a
> way cleaner than my initial one because code does not depend from a
> structure.

Yes, that is better. I still would prefer to have all configuration
attributes nested under some common attribute .. but I can't see a
clean way to do that right now. Let me think about this some more.
