From: "Toby DiPasquale" <codeslinger@gmail.com>
Subject: Re: [MATCH] a match for qq
Date: Thu, 20 Jul 2006 17:47:26 -0400
Message-ID: <876ef97a0607201447l5a58bd52s404f9f7c7fb6e451@mail.gmail.com>
References: <1153176704.15818.1.camel@localhost.localdomain>
	<44BFAEA4.5070507@trash.net>
	<1153366270.24974.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter dev <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: zhongyu@18mail.cn
In-Reply-To: <1153366270.24974.7.camel@localhost.localdomain>
Content-Disposition: inline
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

On 7/19/06, zhongyu <zhongyu@18mail.cn> wrote:
> Ofcause, and I had added the msn support for this match, so the module
> name was changed to ipt_im. I will search the STL protocol and add the
> GoogleTalk support soon (my current idea is match the STL
> certifacation's common name).
> The new code is here
> http://www.18mail.cn/ipt_im.tgz

I think perhaps that multiple match modules, one per IM protocol,
would be best here. For example, ipt_im_qq, ipt_im_jabber, ipt_im_msn,
ipt_im_aim, etc. Having them all in one match module will hinder fast
update when one or another of the supported protocols has changed and
make the match module's code large and unwieldy.

-- 
Toby DiPasquale
0x636f6465736c696e67657240676d61696c2e636f6d
