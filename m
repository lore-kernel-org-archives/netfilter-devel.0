From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Redundant netfilter gateway
Date: Tue, 22 Jun 2004 10:57:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087894660.2358.9.camel@nienna.balabit>
References: <20040619042840.20653.69114.Mailman@vishnu.netfilter.org>
	 <1087830778.1538.54.camel@toshiba>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Luis Pacheco <lpacheco@netvisao.pt>
In-Reply-To: <1087830778.1538.54.camel@toshiba>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-06-21, h keltezéssel 17:12-kor Luis Pacheco ezt írta:
> could you make an brief description, what you have done to make it
> working ?

  You should read Harald's paper on the basic architecture, and have a
look at the second Netfilter Workshop's page, where you can find some
more info on the proof-of-concept implementation.

> Another questions, the libctnetlink is only to syncronize connection
> track. And about rules syncronization should it be an issue of
> high-avaibility ?

  This is a completely unrelated problem, thus it should be solved
administratively. ct_sync is only one low-level component of the
architecture, not even covering the election process of master sites.

-- 
 Regards,
   Krisztian KOVACS
