From: Jon Masters <jonathan@jonmasters.org>
Subject: why is nf_conntrack_htable_size exported?
Date: Fri, 29 Jan 2010 23:32:11 -0500
Message-ID: <1264825931.7156.2.camel@tonnant>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751772Ab0A3EcW@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Folks,

Can someone tell me why nf_conntrack_htable_size is both an exported
symbol, and available in sysfs to be changed? Doing so will surely cause
the system to fall over immediately since this is value is used within
the hashing code in conntrack. It is /supposed/ to only be changed under
a lock, or at init time when there is not a need to lock it.

Perhaps we can get this unexported asap and the value replaced with a
function that returns the current value instead? Same goes for the
module parameter that can freely be messed around with.

Thanks,

Jon.
