From: Patrick Schaaf <bof@bof.de>
Subject: Re: PATCH: extra conntrack stats
Date: Thu, 1 May 2003 08:05:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501060522.GB15143@oknodo.bof.de>
References: <1051743903.8213.188.camel@tux.rsn.bth.se> <20030501050235.F0DCE2C04F@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
  Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
  Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
  Harald Welte <laforge@netfilter.org>,
  Netfilter-devel <netfilter-devel@lists.netfilter.org>,
  Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030501050235.F0DCE2C04F@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> 	struct nf_ct_info infos[IP_CT_NUMBER];
> 7 * 4 bytes.  We could eliminate this by adding an skb field to hold
> the state.

Given a guaranteed cacheline alignment of our 'struct ip_conntrack',
we could make the current pointer on the skbuffs a tagged pointer,
i.e. stuff our 3 info bits into the low 3 bits, without consuming
more room in the skbuffs. The skb_nf_forget() cleanup patch I made
last year, was a preparation for that. With that patch applied,
the ugliness of such a tagged pointer is not visible in the base
network stack (skb_nf_forget() makes the base stack callers
oblivious of what exactly is stored on an skbuff wrt conntracking).

See http://lists.netfilter.org/pipermail/netfilter-devel/2002-July/008703.html

best regards
  Patrick
