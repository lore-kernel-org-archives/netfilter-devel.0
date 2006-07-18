From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [nf-failover] Conntrack schema!!
Date: Tue, 18 Jul 2006 15:22:39 +0200
Message-ID: <200607181522.40035@nienna>
References: <802220ef0607180609v6c362c56h401cb9c8d7b53647@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Ramsurrun Visham <vishamr@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-failover@lists.netfilter.org
In-Reply-To: <802220ef0607180609v6c362c56h401cb9c8d7b53647@mail.gmail.com>
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

On Tuesday 18 July 2006 15.09, Ramsurrun Visham wrote:
> I would like to know if there's a document that explains the different
> parts of the conntrack system (the different functions involved, the
> entry points for packets..etc).

  I'm afraid you're asking this on the wrong list. You should ask Netfilter 
development-related questions on the netfilter-devel (-at-) 
lists.netfilter.org mailing list.

  BTW, I'd recommend Pablo's recent article available here:

  http://people.netfilter.org/pablo/docs/login.pdf

  This provides a quite nice overview of the conntrack system in general. 
Once you know the key data structures and Netfilter concepts reading the 
source code is much easier.

-- 
 Regards,
  Krisztian Kovacs
