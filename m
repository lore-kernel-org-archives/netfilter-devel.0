From: Patrick McHardy <kaber@trash.net>
Subject: Re: tasklist_lock abuse in ipt{,6}owner
Date: Fri, 12 Aug 2005 15:03:59 +0200
Message-ID: <42FC9E3F.9060706@trash.net>
References: <20050809211249.GA29430@lst.de> <42FB449A.7030709@trash.net>
	<20050811152450.GA8189@lst.de> <20050811152942.GA8276@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20050811152942.GA8276@lst.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Christoph Hellwig wrote:
> Ok, here's a patch still leaving the UID/GID matches in and erroring out
> if PID/SID/COMM are specified:

Looks good, thanks. I'm going to pass it on to Dave this weekend.
