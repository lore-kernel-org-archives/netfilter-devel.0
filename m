From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH 0/3] evaluate: Follow linux-kernel coding style
Date: Mon,  2 Oct 2017 13:02:47 +0530
Message-ID: <cover.1506928244.git.harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Issues found using checkpatch.pl 
As per linux-kernel coding style, code indent should use tabs wherever
possible and avoid unnecessary spaces.
Comparisons shoukd place the constant on the right side of the test.
static const char * array should be static const * char const array 

Harsha Sharma (3):
  evaluate: Remove unnecessary spaces
  evaluate: Place constant on right side in comparison
  evaluate: fix checkpatch issue for static const char * array

 src/evaluate.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

-- 
1.9.1
