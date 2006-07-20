From: Patrick McHardy <kaber@trash.net>
Subject: Re: [MATCH] a match for qq
Date: Fri, 21 Jul 2006 01:21:11 +0200
Message-ID: <44C00FE7.4070905@trash.net>
References: <1153176704.15818.1.camel@localhost.localdomain>	
	<44BFAEA4.5070507@trash.net>	
	<1153366270.24974.7.camel@localhost.localdomain>
	<876ef97a0607201447l5a58bd52s404f9f7c7fb6e451@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: zhongyu@18mail.cn, netfilter dev <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Toby DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a0607201447l5a58bd52s404f9f7c7fb6e451@mail.gmail.com>
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

Toby DiPasquale wrote:
> I think perhaps that multiple match modules, one per IM protocol,
> would be best here. For example, ipt_im_qq, ipt_im_jabber, ipt_im_msn,
> ipt_im_aim, etc. Having them all in one match module will hinder fast
> update when one or another of the supported protocols has changed and
> make the match module's code large and unwieldy.

Updates shouldn't really make a difference. I agree with putting it
in seperate matches, but they can still be part of the same module
IMO. We currently have way to many modules basically doing the same
thing (match one field of packet data, match of field of meta data)
and I would like to get rid of the "one match per module" attitude.
