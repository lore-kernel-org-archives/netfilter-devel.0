From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ebtables: handle string from userspace with
 care
Date: Fri, 18 May 2018 09:51:38 +0200
Message-ID: <20180518075138.lgx2aa4cdy6zf5lq@salvia>
References: <8710122d42aa1f3e081812f2abf406973f834982.1524818458.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        syzbot <syzbot+4e42a04e0bc33cb6c087@syzkaller.appspotmail.com>,
        fw@strlen.de, coreteam@netfilter.org,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8710122d42aa1f3e081812f2abf406973f834982.1524818458.git.pabeni@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Apr 27, 2018 at 10:45:31AM +0200, Paolo Abeni wrote:
> strlcpy() can't be safely used on a user-space provided string,
> as it can try to read beyond the buffer's end, if the latter is
> not NULL terminated.

Applied, thanks!
