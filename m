From: "David S. Miller" <davem@redhat.com>
Subject: Re: [BUG] Netfilter in Linux 2.6.1
Date: Fri, 23 Jan 2004 11:42:05 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040123114205.014be03b.davem@redhat.com>
References: <20040123160319.GA2733@schottelius.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, gregor@tecmafia.de,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nico Schottelius <nico-linux-net@schottelius.org>
In-Reply-To: <20040123160319.GA2733@schottelius.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 23 Jan 2004 17:03:19 +0100
Nico Schottelius <nico-linux-net@schottelius.org> wrote:

> Is that right?
> 
> This looks for me like bug in netfilter...

Netfilter first sees the pre-encrypted SSH TCP packets before they are encapsulated
in ESP, and thus your rules say to drop those.

That's just how things work currently.
