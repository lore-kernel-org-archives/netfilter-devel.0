From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] 0/3 Various pom-ng requirements
Date: Tue, 26 Oct 2004 14:19:09 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041026211909.GA2598@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a resend of patches which adjust kernel requirements for
3 pom-ng patches.  These were specifically noticed because as is,
they break 'runme --batch' on 2.4.27.  

Granted, using --batch mode is not the smartest thing in the world,
but someone complained about it in bugzilla, so...

Phil
