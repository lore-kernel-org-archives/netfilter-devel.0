From: Patrick McHardy <kaber@trash.net>
Subject: Re: POM Xtables???
Date: Tue, 01 Jul 2008 16:34:30 +0200
Message-ID: <486A4076.8080007@trash.net>
References: <935fab200806271054oa7c340evbf465b7a9984498b@mail.gmail.com>  <alpine.LNX.1.10.0806272003170.12725@fbirervta.pbzchgretzou.qr>  <4866F152.7030109@riverviewtech.net> <935fab200806300904rc7dc7b2kf58ab7893c3ef20a@mail.gmail.com> <486907EA.60105@trash.net> <alpine.LNX.1.10.0806302218500.30639@fbirervta.pbzchgretzou.qr> <48694787.3080906@trash.net> <Pine.LNX.4.64.0807011135120.30394@blackhole.kfki.hu> <4869FCE7.9000404@trash.net> <alpine.LNX.1.10.0807011326351.12878@fbirervta.pbzchgretzou.qr> <486A1865.40106@trash.net> <486A39BF.4090206@riverviewtech.net> <486A3AD6.7040905@trash.net> <486A3EDA.8030804@riverviewtech.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mail List - Netfilter <netfilter@vger.kernel.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Grant Taylor <gtaylor@riverviewtech.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <486A3EDA.8030804@riverviewtech.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Again, please don't trim CC lists.

Grant Taylor wrote:
> On 07/01/08 09:10, Patrick McHardy wrote:
>> In any case, its unreasonable to expect us to never *extend* (not 
>> change) the output to accomodate buggy parsers. This is by the way 
>> the same way that is often used to extend binary structures, even 
>> though someone stupid might use exact size checks.
>
> *nod*
>
> Agreed.
>
> However as I sit here and think about it, it may be worth adding a new 
> field *as early as possible* (read closes to the start of line) in the 
> field list that indicates a version, which can be used to determine 
> the fields and their position there in.  This would make it very easy 
> for people to write strict parsers down the road.  A simple three 
> character hex field (4 bytes including the leading space) would allow 
> for 4k of strict layouts.  (Even more 0-9 and a-z or additionally 
> A-Z.) Just a thought.

I don't it would be very useful at this time since we already made
those changes over the time of multiple years, so basically the
damage (if any) is already done.

And we have ULOG and nfnetlink_log that should be used for anything
serious for the reasons I stated earlier (more reliable, doesn't block
when using serial consoles, ...).



