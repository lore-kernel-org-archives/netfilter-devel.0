From: Patrick Schaaf <bof@bof.de>
Subject: Re: Easy question, how to use stdio.h
Date: Tue, 22 Apr 2003 19:14:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030422171403.GA3374@oknodo.bof.de>
References: <e3f7fde643.de643e3f7f@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "ISLERO77@telefonica.net" <ISLERO77@telefonica.net>
Content-Disposition: inline
In-Reply-To: <e3f7fde643.de643e3f7f@teleline.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I'm trying to use fopen, fprintf and fclose in a match
> How can I use them???  

You can't. The kernel does not support the userlevel C library.
Note that this is not a mailing list for learning about how to
program the kernel.

best regards
  Patrick
