From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] Make LOG targets log uid/gid
Date: 07 May 2003 22:05:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1052337904.23434.17.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.51.0305072051330.18612@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0305072051330.18612@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-05-07 at 20:55, Maciej Soltysiak wrote:
> Hi,
> 
> This patch makes both of the LOG targets log uid and gid of a process
> that owns the socket related to the sk_buff.

Why not do somethine along the lines of
http://www.netfilter.org/~gandalf/patches/ipt_LOG-uid.diff

It adds an option for the uid logging (it doesn't log gid)
everything else are options so I think this should be too.

It doesn't really break compability, old userspace still works with the
kernelpart patch and new userspace still works without the kernelpart
except that uid logging won't work (and ipt_LOG won't complain and the
uid option is showed in print/save since ipt_LOG doesn't check
IPT_LOG_MASK)

-- 
/Martin
