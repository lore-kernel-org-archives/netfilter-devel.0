From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: MAC address matching. Or other ideas.
Date: Sat, 10 May 2003 15:24:16 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0305101521550.1781@dns.toxicfilms.tv>
References: <3EB5A38C.4090606@dev-zone.org> <20030510105942.GB28426@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Daniel <daniel@dev-zone.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030510105942.GB28426@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> You could, maybe, be lucky to have it in the POSTROUTING table. But I
> doubt that.
Hmm, how about an another netfilter hook somewhere in the output code
path, when the dst mac is known?

Regards,
Maciej
