From: "Jesse Peng" <Jesse@deansoft.com.tw>
Subject: Re: [PATCH] Don't increase master refcount on expectations
Date: Mon, 12 Sep 2005 06:38:05 +0800
Message-ID: <001f01c5b721$7a0f1620$fefefe0a@jesseh7ht76e8n>
References: <430E2DF9.8060802@eurodev.net><000801c5aa3a$5bd49250$1501a8c0@test1>
	<200509070501.j87516JU006636@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net, kaber@trash.net, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Yasuyuki KOZAKAI" <yasuyuki.kozakai@toshiba.co.jp>
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

Dear Yasuyuki

> Well, it's questionable that I correctly understand your scenario, but
> I think there is no problem. 1. As Pablo said, expectations in list are
> destroyed by its master before master is destroyed, so ip_conntrack_put()
> doesn't cause problem. And because the refcount of master conntrack is
> incremented when the expected packets arrived, master conntrack can be
kept
> after that. See init_conntrack() in detail.

Anyway,thanks for your reply!

Your sincerely
Jesse
