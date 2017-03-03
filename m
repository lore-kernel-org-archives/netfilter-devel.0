From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH V3] audit: normalize NETFILTER_PKT
Date: Fri, 3 Mar 2017 12:08:22 -0500
Message-ID: <20170303170822.GJ18258@madcap2.tricolour.ca>
References: <044a666e507a829f8c1d6dcc19ad78cd9f140ddd.1488142060.git.rgb@redhat.com>
	<CAHC9VhTUSz-tyPyZ7PJAH08sfhuACeUTkEKEnnwM_axQ4UdorQ@mail.gmail.com>
	<20170301162802.GV18258@madcap2.tricolour.ca>
	<CAHC9VhTHfyPR-yj4kOAJBeU4D1=o4Uu-=S_STvQoj4OAr9Y-mQ@mail.gmail.com>
	<20170301223447.GA18258@madcap2.tricolour.ca>
	<CAHC9VhRGSzea_c9Gg-Z3gr8cu2UQA9DhNtba0tf9AShoNakxzw@mail.gmail.com>
	<20170303020007.GF18258@madcap2.tricolour.ca>
	<CAHC9VhRoy1TR46ZLfzLB1wzOq=VZfX-RnG=7ogVP1Xphk=qtBg@mail.gmail.com>
	<20170303115416.GH18258@madcap2.tricolour.ca>
	<20170303124526.GC29213@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Woerner <twoerner@redhat.com>, linux-audit@redhat.com,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170303124526.GC29213@breakpoint.cc>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

On 2017-03-03 13:45, Florian Westphal wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Perhaps I'm missing something here, but let me ask again, how does
> > > userspace distinguish between an unset nfmark and a nfmark of
> > > 0xffffffff?
> > 
> > It can't.
> 
> It can if you log it as 0, as I asked in patch 1 review.

I'd be inclined to do that, since it will always have a value even if
its default is zero.

The proto field would actually be unset if it was a protocol family that
did not have a protocol field.

> (You wouldn't log sk uid of 0 as -1 either, would you?)

No, but you would log auid and session id as -1 if it were unset.


- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
