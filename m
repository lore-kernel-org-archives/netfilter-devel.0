Received: from felix.runs.onstackit.cloud (felix.runs.onstackit.cloud [45.129.43.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B98A7
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 01:34:36 -0800 (PST)
Date: Tue, 5 Dec 2023 09:34:30 +0000
From: Felix Huettner <felix.huettner@mail.schwarz>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack 0/2] dump/flush support filtering by
 zone
Message-ID: <cover.1701675975.git.felix.huettner@mail.schwarz>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

this patchset expands libnetfilter_conntrack to send dump and flush requests
that filter by conntrack zone.
It is dependent on a patch to the kernel repo at
https://marc.info/?l=linux-kernel&m=170108582310775

Felix Huettner (2):
  dump: support filtering by zone
  flush: support filtering

 include/internal/object.h                     |  1 +
 include/internal/prototypes.h                 |  1 +
 .../libnetfilter_conntrack.h                  |  5 ++
 src/conntrack/api.c                           | 14 +++++
 src/conntrack/build_mnl.c                     |  3 +
 src/conntrack/filter_dump.c                   | 17 ++++++
 utils/.gitignore                              |  1 +
 utils/Makefile.am                             |  4 ++
 utils/conntrack_dump_filter.c                 |  2 +
 utils/conntrack_flush_filter.c                | 60 +++++++++++++++++++
 10 files changed, 108 insertions(+)
 create mode 100644 utils/conntrack_flush_filter.c

-- 
2.43.0

