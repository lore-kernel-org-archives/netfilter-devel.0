From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: libiptc memory leak - PATCH
Date: 02 May 2003 15:47:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051883276.3811.24.camel@tux.rsn.bth.se>
References: <3EA46FDE.6040806@i.cz>
	 <20030427125345.GD990@sunbeam.de.gnumonks.org> <3EACD4D1.90704@i.cz>
	 <20030430154721.GD685@sunbeam.de.gnumonks.org>
	 <1051879671.3823.17.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: =?ISO-8859-1?Q?Tom=E1=3F?= Lejdar <tomas.lejdar@i.cz>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <1051879671.3823.17.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2003-05-02 at 14:47, Martin Josefsson wrote:

> This patch breaks {ip,ip6}tables-{save,restore} and it runs free() on
> the wrong memoryaddress (I think free() does the right thing anyway but
> the patch still breaks stuff).

Ok, I was wrong, it did free on a correct memoryaddress, I'll fix up my
patch and resend, sorry about that.

-- 
/Martin
