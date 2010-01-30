From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: why is nf_conntrack_htable_size exported?
Date: Fri, 29 Jan 2010 23:38:36 -0500
Message-ID: <1264826316.7499.1.camel@tonnant>
References: <1264825931.7156.2.camel@tonnant>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751874Ab0A3Eiq@vger.kernel.org>
In-Reply-To: <1264825931.7156.2.camel@tonnant>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2010-01-29 at 23:32 -0500, Jon Masters wrote:

> Can someone tell me why nf_conntrack_htable_size is both an exported
> symbol, and available in sysfs to be changed?

Ah, ignore me, it does go through a function, it's just that if it's
already zero we assume it's "init time", which isn't true if the value
has otherwise been fiddled with - I think that assumption probably is
worth looking at anyway, and it's worth the hashing functions looking to
see if the value is NULL, to catch that aswell.

Jon.
