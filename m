From: insecure <insecure@mail.od.ua>
Subject: Re: I see wrong ip on icmp_need_fragment. MASQUERADE+less_than_1500_MTU_link+nfs
Date: Sun, 24 Aug 2003 03:42:28 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308240342.28529.insecure@mail.od.ua>
References: <200308141317.h7EDHad01974@Port.imtp.ilyichevsk.odessa.ua> <20030823210759.GD6750@sunbeam.de.gnumonks.org>
Reply-To: insecure@mail.od.ua
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
 Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>
In-Reply-To: <20030823210759.GD6750@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > Hi folks,
> >
> > Please CC me, I'm not on the list.
> >
> > I think I see a bug.
>
> Unfortunately you didn't tell us which exact kernel version you were
> using while experiencing the described behaviour.
>
> Could you please file a bug about this to bugzilla.netfilter.org with
> the kernel version and all details?  thanks.
>
> > Is this a known problem?
>
> we've had this bug in the past - but it's assumed to be fixed since
> quite some time (2.4.19 or 2.4.20, I think).

I am sorry. Seems like I indeed tripped over an old bug.
It is fixed in 2.4.21

Thanks folks for your incredible work!
-- 
vda
