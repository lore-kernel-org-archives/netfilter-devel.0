From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Sun, 26 Feb 2017 14:09:00 -0500
Message-ID: <20170226190900.GA20724@madcap2.tricolour.ca>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
	<10185842.hTv0ExFpgc@x2>
	<20170210225445.GS26850@madcap2.tricolour.ca>
	<3926301.2G9jBBrVEf@x2>
	<20170213205005.GO26855@madcap2.tricolour.ca>
	<CAHC9VhTGJMtg6z-WjW+PYCrEAKdrrKhfJdi3j4DB=91r8XYH4Q@mail.gmail.com>
	<20170214002452.GT26850@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170214002452.GT26850@madcap2.tricolour.ca>
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

On 2017-02-13 19:24, Richard Guy Briggs wrote:
> On 2017-02-13 18:50, Paul Moore wrote:
> > On Mon, Feb 13, 2017 at 3:50 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > > useless?        smac, dmac, macproto
> > 
> > Probably useless in the majority of use cases.
> 
> How do we deal with the minority of cases where it could be quite useful?

It turns out this was required for ebtables support.
	https://bugzilla.redhat.com/show_bug.cgi?id=642391#c6

> > > - RGB
> > 
> > paul moore
> 
> - RGB

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
