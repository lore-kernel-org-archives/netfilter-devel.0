From: Michal Rokos <michal@rokos.info>
Subject: Re: nf_conntrack resync with 2.6.11-rc4
Date: Tue, 15 Feb 2005 16:54:56 +0100
Message-ID: <200502151654.57371.michal@rokos.info>
References: <20050215124751.GZ3829@sunbeam.de.gnumonks.org>
	<200502151615.23463.michal@rokos.info>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200502151615.23463.michal@rokos.info>
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

Hello again,

On Tuesday 15 February 2005 16:15, Michal Rokos wrote:
> On Tuesday 15 February 2005 13:47, Harald Welte wrote:
> > Since lots of changes went into ip_conntrack over the last months, I
> > went through the pain of re-synchronizing nf_conntrack with
> > ip_conntrack, hopefully this was the last time.
>
> isn't this one missing?

And more....

in net/netfilter/nf_conntrack_ftp.c there's helper like
static int help(struct sk_buff **pskb,
                unsigned int protoff,
                struct nf_conn *ct,
                enum nf_conntrack_info ctinfo) {}

but prototype defined in include/linux/netfilter/nf_conntrack_helper.h is as
int (*help)(struct sk_buff **pskb,
                    struct nf_conn *ct,
                    enum nf_conntrack_info conntrackinfo);

I'm sorry that patch isn't included...

 Michal
