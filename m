From: James Morris <jmorris@intercode.com.au>
Subject: Re: libipq and packet owner
Date: Sat, 2 Aug 2003 01:26:37 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0308020125550.29556-100000@excalibur.intercode.com.au>
References: <20030801151507.GA5166@ezoteryk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Olgierd Pieczul <wojrus@linux.slupsk.net>
In-Reply-To: <20030801151507.GA5166@ezoteryk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 1 Aug 2003, Olgierd Pieczul wrote:

> Hi,
> How can i get (if possible), the "owner" (pid, uid, ...) of packet
> recieved from netlink in userspace program?

This information is not available via ip_queue.


- James
-- 
James Morris
<jmorris@intercode.com.au>
