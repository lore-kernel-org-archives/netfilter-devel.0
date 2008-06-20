From: "Adelson O. Junior" <jroliv@gmail.com>
Subject: Re: NFNETLINK answers: No such file or directory
Date: Fri, 20 Jun 2008 18:12:26 -0300
Message-ID: <7b0a40830806201412i1c9353cas696982909cf25781@mail.gmail.com>
References: <7b0a40830806181538s40efbd70s66aec17d5c04933@mail.gmail.com>
	 <485B97E7.4000501@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:10329 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbYFTVM5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:12:57 -0400
Received: by an-out-0708.google.com with SMTP id d40so322176and.103
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2008 14:12:56 -0700 (PDT)
In-Reply-To: <485B97E7.4000501@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The command sounds like this:

/usr/sbin/conntrack -D --p udp --orig-src 202.x.x.47 --orig-port-src
14276 --orig-dst 202.x.x.155 --orig-port-dst 20000 --reply-src
202.x.x.89 --reply-port-src 28246 --reply-dst 202.x.x.155
--reply-port-dst 20002

but, I think that there's no bug. Simply there's no conntrack entry.

Error: NFNETLINK answers: No such file or directory
Error: Operation failed: such conntrack doesn't exist
No contrack entry where found on from->to way trying to->from

I think that don't came packets that match with the iptables rule and
conntrack was not created. And can't be deleted.
I will search for bug in the application.

Thanks Pablo.
Adelson


On Fri, Jun 20, 2008 at 8:43 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Adelson O. Junior wrote:
>> Hi netfiltel mail list,
>> it's my first time here.
>>
>> My question is:
>> I'm trying to delete a entry in the conntrack and an Error is shown:
>>
>> "NFNETLINK answers: No such file or directory"
>>
>> I did a "small" search on the Internet, mail list and I saw that this
>> is a bug and is already fixed.
>> Can you tell if this is true, and if is, what the version of
>> libnfnetlink, libnetfilter_conntrack or
>> conntrack packets (and witch of them have a problem) that the bug is fixed?
>
> Could you post the command line invocation of `conntrack' that you're
> using? It seems to me that you're omitting some required values. Old
> versions require source and destination IP plus port source and
> destination to work, ie.
>
> conntrack -D -s 140.x.x.90 -d 213.x.x.117 -p tcp --sport 34075 --dport 993
>
> As said, probably you're omitting any of those parameters. Some old
> versions of the tool do not perform strict checking on the input
> parameters. Thus, leading to this sort of errors.
>
> The current version (0.9.7) supports more flexible conntrack deletion, eg.
>
> conntrack -D -d 213.x.x.117
>
> This invocation destroys all entries that match that.
>
> --
> "Los honestos son inadaptados sociales" -- Les Luthiers
>



-- 
[]'s
