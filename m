From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: Mailing list slow?
Date: Tue, 20 Jun 2006 12:57:14 +0200
Message-ID: <200606201257.16272.max@nucleus.it>
References: <4496C3D7.2040809@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4496C3D7.2040809@trash.net>
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

On Monday 19 June 2006 5:33 pm, Patrick McHardy wrote:

> Is it just me or are other people also experiencing large
> delays with mails to netfilter-devel? My mails are visible
> on the lists.netfilter.org web interface but I receive them
> with large delay ..

Some of my messages took 24 hours to make it throu (after being delivered to 
vishnu.netfilter.org).

On several occasions I had problem sending them in the first place. Here is 
one of my postfix logs:

Jun 18 09:16:53 waobagger postfix/smtp[9876]: 685DC3D3353: 
to=<netfilter-devel@lists.netfilter.org>, 
relay=vishnu.netfilter.org[213.95.27.115], delay=30082, status=deferred (host 
vishnu.netfilter.org[213.95.27.115] said: 451 Error while writing spool file 
(in reply to end of DATA command))

-- 
Saluti,
   Massimiliano Hofer
