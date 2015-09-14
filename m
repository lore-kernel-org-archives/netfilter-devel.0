From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/2 -stable-3.12 ] netfilter: nf_conntrack: don't release
 a conntrack with non-zero refcnt
Date: Mon, 14 Sep 2015 16:29:08 +0200
Message-ID: <55F6D9B4.1020407@suse.cz>
References: <1441974368-5399-1-git-send-email-pablo@netfilter.org>
 <1441974368-5399-2-git-send-email-pablo@netfilter.org>
 <20150911123811.GB5728@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: stable@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150911123811.GB5728@salvia>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 09/11/2015, 02:38 PM, Pablo Neira Ayuso wrote:
> On Fri, Sep 11, 2015 at 02:26:08PM +0200, Pablo Neira Ayuso wrote:
>> [ Upstream commit cb585e1b1d072d1d7caebc649364b9c46c27ea8f ]
> 
> The right upstream commit is e53376bef2cd97d3e3f61fdc677fb8da7d03d0da.

Both applied with the right SHA, thanks!

-- 
js
suse labs
