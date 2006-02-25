From: Patrick McHardy <kaber@trash.net>
Subject: Re: New H.323 conntrack & NAT helper module
Date: Sat, 25 Feb 2006 19:43:13 +0100
Message-ID: <4400A541.9080901@trash.net>
References: <925A849792280C4E80C5461017A4B8A2032119@mail733.InfraSupportEtc.com><BAY109-DAV1E3EEAC01132FB3EE2E2EB3F00@phx.gbl>
	<44001CDD.3030305@trash.net>
	<BAY109-DAV1A4C43C331B9AEBC1F22EB3F00@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Greg Scott <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV1A4C43C331B9AEBC1F22EB3F00@phx.gbl>
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

Jing Min Zhao wrote:
>> I'm almost done reviewing it. It really looks great, it is the IMO
>> cleanest conntrack helper so far, which is really an achievement
>> for such a complex thing. I've fixed a number of smaller issues
>> and prepared patches for that, I'll send the first batch in follow-up
>> mail.
> 
> 
> I've seen all your patches. I can't believe this. I spent almost 2
> months to
> write the code, but it took you only 3 days to find out so many issues!
> And I know you were still doing other things while you were reviewing my
> code. Now I know not everybody can do the work you guys are doing.

Thanks, I'm pretty good at finding bugs :)


>> Besides my patches, I have a few small issues with the patch, but if
>> they are resolved I'd be happy to put this helper into 2.6.17.
>>
> 
> This is really great news! I'll try my best.
> 
>> The issues so far:
>>
>> - ASN1 parser: I would prefer the parser to be seperated from the
>>  H.225/H.245 data.
>>
> 
> OK, I'll seperate them. I was just trying to make the code look clean.

I wouldn't put them in the helper itself, maybe just a seperate file,
ip_conntrack_h323_helper_asn.c or something like that.


>> - ASN1 parser: Right now the H.225/H.245 data includes lots of
>>  forward declarations, probably because it seem to be in the
>>  same order as in the ASN.1 file. The forward declarations make
>>  it a lot harder to verify that their is no recursion, so I would
>>  prefer to have the data ordered in a way that doesn't need them.
>>
> 
> I generated the object definitions using a parser. I was too lazy to
> sort them. But
> it seems not a good format for the kernel. I'll modify my parser to sort
> them.

So you automatically generated them? It would be nice to have the script
and the ASN1 files integrated in the build process and generate the
structures on the fly, in that case I wouldn't care about the order.
Forward  declarations just make it hard to verify that their is no
recursion, without them it trivial, there can't be any.


>> - TPKT handling: I've seen gnomemeeting send nested TPKTs about a year
>>  ago when I worked on my helper. I can't get it do it anymore, but my
>>  question is if it nested TPKTs are something that should be supported.
>>
> 
> What kind of nested TPKTs do you mean? A packet containing multiple
> TPKTs or
> a TPKT containing another TPKT? I can't imagine the latter situation.
> But if it's the first
> situation, you are right. I didn't think of this.  Thank you.

I meant TPKTs following TPKTs. The non-linear SKB patch should make
it easy to support them since the data pointer isn't reloaded by
the NAT part anymore.


>> - RAS tracking: should be made optional IMO. This is the only part
>>  where foreign IP addresses not belonging to the connection are
>>  used for expectations, which is potentially dangerous.
>>
> 
> I totally agree with you. I'll add a parameter for this.
> 
> 
>> I'll describe the other issues in the mails containing the patches.
>>
>>
> 
> Thank you so much!

Well, thank you, This is really great work. I forgot one small issue:
there seems to be some debugging-leftover, the functions registering
expectations add up the number of registered expectations and return
that value, but nobody uses it. If there are no plans for using it,
I would prefer to have it removed.
