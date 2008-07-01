From: Patrick McHardy <kaber@trash.net>
Subject: Re: POM Xtables???
Date: Tue, 01 Jul 2008 16:10:30 +0200
Message-ID: <486A3AD6.7040905@trash.net>
References: <935fab200806271054oa7c340evbf465b7a9984498b@mail.gmail.com>  <alpine.LNX.1.10.0806272003170.12725@fbirervta.pbzchgretzou.qr>  <4866F152.7030109@riverviewtech.net> <935fab200806300904rc7dc7b2kf58ab7893c3ef20a@mail.gmail.com> <486907EA.60105@trash.net> <alpine.LNX.1.10.0806302218500.30639@fbirervta.pbzchgretzou.qr> <48694787.3080906@trash.net> <Pine.LNX.4.64.0807011135120.30394@blackhole.kfki.hu> <4869FCE7.9000404@trash.net> <alpine.LNX.1.10.0807011326351.12878@fbirervta.pbzchgretzou.qr> <486A1865.40106@trash.net> <486A39BF.4090206@riverviewtech.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mail List - Netfilter <netfilter@vger.kernel.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Grant Taylor <gtaylor@riverviewtech.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <486A39BF.4090206@riverviewtech.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Please don't trim CC lists.

Grant Taylor wrote:
> On 07/01/08 06:43, Patrick McHardy wrote:
>> As for the argument of parsers that might not handle this: any parser 
>> needs to expect new things to be added at the end of the line...
>
> *LOL*
>
> Now you are expecting people to do what they should verses what is easy.
>
> Unfortunately, what is considered best practice (at the time) is not 
> followed often enough.


We had multiple format extensions over time, you would hope
that people learn from their mistakes. Using scanf or a
lexer+scanner its probably impossible to even make this mistake,
assuming some perl parser someone would have to specifically
match on the (completely useless for parsing purposes) end of
line.

In any case, its unreasonable to expect us to never *extend*
(not change) the output to accomodate buggy parsers. This is
by the way the same way that is often used to extend binary
structures, even though someone stupid might use exact size
checks.


