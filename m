From: dmitry pervushin <dmitry.pervushin@linaro.org>
Subject: [PATCH 0/2]  netfilter: idletimers
Date: Sun, 21 Apr 2013 11:53:12 +0200
Message-ID: <1366537994-19511-1-git-send-email-dmitry.pervushin@linaro.org>
Cc: patches@linaro.org
To: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello all,

[PATCH 1/2] netfilter: idletimers - fix the case of already expired timer
[PATCH 2/2] netfilter: idletimers - add send_nl_msg field

These two patches fix the case of already expired timer and add capability to send netlink message notifications in addition to sysfs notifications (previous serie was started here: http://article.gmane.org/gmane.linux.kernel/1362838)
