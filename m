From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: conntrack for multiple interfaces
Date: Tue, 17 Jan 2006 09:27:51 +0100
Message-ID: <200601170927.51550@nienna>
References: <200601161355.22867.kgy@deverto.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Kovesdi Gyorgy <kgy@deverto.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200601161355.22867.kgy@deverto.com>
Content-Disposition: inline
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


  Hi,

On Monday 16 January 2006 13.55, Kovesdi Gyorgy wrote:
> Is there any special mailing list for libnetfiler_conntrack?

  I don't think so, you should use netfilter-devel for that purpose.

> My machine has assigned the same IP range for multiple interfaces. Is the
> conntrack able to handle this?

  Conntrack does not care about interfaces at all, so from conntrack's point 
of view having multiple interfaces with the same IP range assigned makes no 
difference.

-- 
 Regards,
  Krisztian Kovacs
